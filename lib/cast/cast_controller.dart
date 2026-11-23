import 'dart:async';

import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:bonsoir/bonsoir.dart';
import 'package:cast/device.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/models.dart';
import '../audio/player.dart';

/// Google Cast default receiver: plays an audio URL with cover art and title.
const _defaultReceiver = 'CC1AD845';
const _nsReceiver = 'urn:x-cast:com.google.cast.receiver';
const _nsMedia = 'urn:x-cast:com.google.cast.media';

class CastState {
  /// Chromecasts found on the network.
  final List<CastDevice> devices;
  final bool searching;

  /// Device in use (or connecting).
  final CastDevice? device;
  final bool connecting;
  final String? error;

  const CastState({
    this.devices = const [],
    this.searching = false,
    this.device,
    this.connecting = false,
    this.error,
  });

  bool get active => device != null && !connecting;

  CastState copyWith({
    List<CastDevice>? devices,
    bool? searching,
    CastDevice? device,
    bool clearDevice = false,
    bool? connecting,
    String? error,
    bool clearError = false,
  }) => CastState(
    devices: devices ?? this.devices,
    searching: searching ?? this.searching,
    device: clearDevice ? null : device ?? this.device,
    connecting: connecting ?? this.connecting,
    error: clearError ? null : error ?? this.error,
  );
}

/// Chromecast: finds devices on the network (mDNS `_googlecast._tcp`), connects to the default
/// receiver and becomes the player's output ([RemoteOutput]): the queue stays in the app, and each
/// track is sent to the device by URL (the Chromecast downloads straight from Jellyfin).
class CastController extends Notifier<CastState> implements RemoteOutput {
  CastSession? _session;
  StreamSubscription? _msgSub, _stateSub;
  Timer? _tick;
  int _req = 1;
  int? _mediaSessionId;

  // Position: the device only reports when its state changes; between reports, we estimate.
  Duration _basePos = Duration.zero;
  DateTime _baseAt = DateTime.now();
  bool _playing = false;
  bool _loading = false; // sent LOAD and the PLAYING/PAUSED of the new track has not arrived yet

  PlayerController get _player => ref.read(playerProvider.notifier);

  @override
  CastState build() {
    ref.onDispose(_cleanup);
    return const CastState();
  }

  // ---------- discovery ----------

  Future<void> search({Duration timeout = const Duration(seconds: 5)}) async {
    if (state.searching) return;
    state = state.copyWith(searching: true, clearError: true);
    final found = <String, CastDevice>{};
    BonsoirDiscovery? d;
    try {
      d = BonsoirDiscovery(type: '_googlecast._tcp', printLogs: false);
      await d.initialize();
      final disc = d;
      final sub = disc.eventStream!.listen((e) {
        switch (e) {
          case BonsoirDiscoveryServiceFoundEvent():
            disc.serviceResolver.resolveService(e.service);
          case BonsoirDiscoveryServiceResolvedEvent():
            final s = e.service;
            final host =
                s.hostAddresses.where((a) => !a.contains(':')).firstOrNull ??
                s.hostAddress ??
                s.hostname;
            if (host == null) return;
            final name = s.attributes['fn'] ?? s.name;
            found[s.name] = CastDevice(
              serviceName: s.name,
              name: name,
              host: host,
              port: s.port,
              extras: s.attributes,
            );
            state = state.copyWith(devices: found.values.toList());
          default:
        }
      });
      await disc.start();
      await Future<void>.delayed(timeout);
      await sub.cancel();
    } catch (_) {
      // no local network permission or no Wi-Fi: the list stays empty
    } finally {
      try {
        await d?.stop();
      } catch (_) {}
      state = state.copyWith(
        searching: false,
        devices: found.isEmpty ? state.devices : found.values.toList(),
      );
    }
  }

  // ---------- connection ----------

  Future<void> connect(CastDevice device) async {
    await disconnect(resumeHere: false);
    state = state.copyWith(device: device, connecting: true, clearError: true);
    try {
      final s = await CastSessionManager().startSession(
        device,
        const Duration(seconds: 8),
      );
      _session = s;
      final ready = Completer<void>();
      _stateSub = s.stateStream.listen((st) {
        if (st == CastSessionState.connected && !ready.isCompleted) {
          ready.complete();
        } else if (st == CastSessionState.closed) {
          _lost();
        }
      });
      _msgSub = s.messageStream.listen(_onMessage, onError: (_) {});
      _send(_nsReceiver, {'type': 'LAUNCH', 'appId': _defaultReceiver});
      await ready.future.timeout(const Duration(seconds: 15));
      _send(_nsMedia, {'type': 'GET_STATUS'});
      state = state.copyWith(connecting: false);
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        _player.remotePosition(position);
      });
      await _player.setOutput(this, name: device.name);
    } catch (_) {
      _cleanup();
      state = state.copyWith(
        clearDevice: true,
        connecting: false,
        error: device.name,
      );
    }
  }

  /// Stops casting. [resumeHere]: the queue returns to this device, paused at the same point.
  Future<void> disconnect({bool resumeHere = true}) async {
    if (_session == null && state.device == null) return;
    final pos = position;
    final s = _session;
    final id = _mediaSessionId;
    try {
      // After connecting, messages go to the receiver app: stop the music there.
      if (id != null) _send(_nsMedia, {'type': 'STOP', 'mediaSessionId': id});
      await s?.flush();
    } catch (_) {}
    _cleanup(); // before closing: the connection's "closed" event is not a drop
    try {
      if (s != null) await CastSessionManager().endSession(s.sessionId);
    } catch (_) {}
    state = state.copyWith(clearDevice: true, connecting: false);
    if (resumeHere) await _player.setOutput(null, at: pos);
  }

  void _lost() {
    if (_session == null) return;
    final pos = position;
    _cleanup();
    state = state.copyWith(clearDevice: true, connecting: false);
    unawaited(_player.setOutput(null, at: pos));
  }

  void _cleanup() {
    _tick?.cancel();
    _tick = null;
    _msgSub?.cancel();
    _stateSub?.cancel();
    _msgSub = _stateSub = null;
    _session = null;
    _mediaSessionId = null;
    _playing = false;
    _loading = false;
  }

  void _send(String ns, Map<String, dynamic> payload) {
    _session?.sendMessage(ns, {...payload, 'requestId': _req++});
  }

  void _onMessage(Map<String, dynamic> m) {
    if (m['type'] != 'MEDIA_STATUS') return;
    final list = m['status'];
    if (list is! List || list.isEmpty) return;
    final st = list.first as Map<String, dynamic>;
    _mediaSessionId =
        (st['mediaSessionId'] as num?)?.toInt() ?? _mediaSessionId;
    final t = (st['currentTime'] as num?)?.toDouble();
    if (t != null) {
      _basePos = Duration(milliseconds: (t * 1000).round());
      _baseAt = DateTime.now();
    }
    final ps = st['playerState'] as String?;
    switch (ps) {
      case 'PLAYING':
        _loading = false;
        _playing = true;
        _player.remoteStatus(playing: true, buffering: false);
      case 'PAUSED':
        _loading = false;
        _playing = false;
        _player.remoteStatus(playing: false, buffering: false);
      case 'BUFFERING':
        _player.remoteStatus(playing: _playing, buffering: true);
      case 'IDLE':
        final why = st['idleReason'] as String?;
        // the previous track stopped because we sent another one
        if (_loading) return;
        _playing = false;
        if (why == 'FINISHED' || why == 'ERROR') {
          _player.remoteEnded();
        } else {
          _player.remoteStatus(playing: false, buffering: false);
        }
    }
  }

  // ---------- RemoteOutput (the player sends playback here) ----------

  @override
  Future<void> load(
    Item item,
    String url,
    MediaItem meta, {
    required Duration at,
    required bool play,
  }) async {
    _loading = true;
    _basePos = at;
    _baseAt = DateTime.now();
    _playing = false;
    _send(_nsMedia, {
      'type': 'LOAD',
      'autoplay': play,
      'currentTime': at.inMilliseconds / 1000,
      'media': {
        'contentId': url,
        'contentType': url.contains('.m3u8')
            ? 'application/x-mpegURL'
            : 'audio/mpeg',
        'streamType': 'BUFFERED',
        'metadata': {
          'metadataType': 3, // MusicTrackMediaMetadata
          'title': meta.title,
          'artist': meta.artist ?? '',
          'albumName': meta.album ?? '',
          if (meta.artUri != null)
            'images': [
              {'url': meta.artUri.toString()},
            ],
        },
      },
    });
  }

  @override
  Future<void> play() async {
    final id = _mediaSessionId;
    if (id != null) _send(_nsMedia, {'type': 'PLAY', 'mediaSessionId': id});
  }

  @override
  Future<void> pause() async {
    final id = _mediaSessionId;
    if (id == null) return;
    _basePos = position;
    _baseAt = DateTime.now();
    _send(_nsMedia, {'type': 'PAUSE', 'mediaSessionId': id});
  }

  @override
  Future<void> seek(Duration d) async {
    final id = _mediaSessionId;
    if (id == null) return;
    _basePos = d;
    _baseAt = DateTime.now();
    _send(_nsMedia, {
      'type': 'SEEK',
      'mediaSessionId': id,
      'currentTime': d.inMilliseconds / 1000,
    });
  }

  @override
  Future<void> setVolume(double v) async {
    // Volume of this track on the receiver (does not touch the TV/speaker volume).
    final id = _mediaSessionId;
    if (id == null) return;
    _send(_nsMedia, {
      'type': 'SET_VOLUME',
      'mediaSessionId': id,
      'volume': {'level': v.clamp(0.0, 1.0)},
    });
  }

  @override
  bool get playing => _playing;

  @override
  Duration get position =>
      _playing ? _basePos + DateTime.now().difference(_baseAt) : _basePos;
}

final castProvider = NotifierProvider<CastController, CastState>(
  CastController.new,
);
