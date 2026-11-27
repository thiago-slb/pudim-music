// Real PlayerController on a fake audio engine and a fake Jellyfin, to test the queue end to end.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/audio/player.dart';
import 'package:pudim_music/state/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The prefs the rig uses (to reopen the "app" with the same saved state).
final prefsProviderForTest = prefsProvider;

Item track(String id, {String? album}) => Item(
  id: id,
  name: 'Song $id',
  kind: ItemKind.track,
  albumId: album,
  duration: const Duration(minutes: 3),
);

List<Item> tracks(String prefix, int n) => [
  for (var i = 0; i < n; i++) track('$prefix$i', album: '${prefix}album'),
];

class FakeJustAudio extends JustAudioPlatform with MockPlatformInterfaceMixin {
  FakeAudio? last;
  @override
  Future<AudioPlayerPlatform> init(InitRequest request) async =>
      last = FakeAudio(request.id);
  @override
  Future<DisposePlayerResponse> disposePlayer(DisposePlayerRequest r) async =>
      DisposePlayerResponse();
  @override
  Future<DisposeAllPlayersResponse> disposeAllPlayers(
    DisposeAllPlayersRequest r,
  ) async => DisposeAllPlayersResponse();
}

/// Plays nothing: keeps the loaded list (track ids), the index, the position and play/pause.
class FakeAudio extends AudioPlayerPlatform {
  FakeAudio(super.id);
  final _events = StreamController<PlaybackEventMessage>.broadcast();
  final _data = StreamController<PlayerDataMessage>.broadcast();
  List<String> ids = [];
  int index = 0;
  Duration pos = Duration.zero;
  bool playing = false;
  var state = ProcessingStateMessage.idle;
  Completer<void>? _playing;
  int loads = 0;

  String? get current => index < ids.length ? ids[index] : null;

  static String _id(AudioSourceMessage m) {
    if (m is UriAudioSourceMessage) {
      return RegExp(r'/Audio/([^/]+)/').firstMatch(m.uri)?.group(1) ?? m.uri;
    }
    return '?';
  }

  void _emit() => _events.add(
    PlaybackEventMessage(
      processingState: state,
      updateTime: DateTime.now(),
      updatePosition: pos,
      bufferedPosition: pos,
      duration: const Duration(minutes: 3),
      icyMetadata: null,
      currentIndex: index,
      androidAudioSessionId: null,
    ),
  );

  @override
  Stream<PlaybackEventMessage> get playbackEventMessageStream => _events.stream;
  @override
  Stream<PlayerDataMessage> get playerDataMessageStream => _data.stream;

  @override
  Future<LoadResponse> load(LoadRequest request) async {
    loads++;
    final m = request.audioSourceMessage;
    ids = m is ConcatenatingAudioSourceMessage
        ? m.children.map(_id).toList()
        : [_id(m)];
    index = request.initialIndex ?? 0;
    pos = request.initialPosition ?? Duration.zero;
    state = ProcessingStateMessage.ready;
    _emit();
    return LoadResponse(duration: const Duration(minutes: 3));
  }

  @override
  Future<PlayResponse> play(PlayRequest request) async {
    if (playing) return PlayResponse();
    playing = true;
    if (state == ProcessingStateMessage.completed) {
      state = ProcessingStateMessage.ready;
    }
    _emit();
    _playing = Completer();
    await _playing!.future;
    return PlayResponse();
  }

  @override
  Future<PauseResponse> pause(PauseRequest request) async {
    playing = false;
    _playing?.complete();
    _playing = null;
    _emit();
    return PauseResponse();
  }

  @override
  Future<SeekResponse> seek(SeekRequest request) async {
    pos = request.position ?? Duration.zero;
    index = request.index ?? index;
    if (state == ProcessingStateMessage.completed) {
      state = ProcessingStateMessage.ready;
    }
    _emit();
    return SeekResponse();
  }

  @override
  Future<ConcatenatingInsertAllResponse> concatenatingInsertAll(
    ConcatenatingInsertAllRequest r,
  ) async {
    ids.insertAll(r.index, r.children.map(_id));
    _emit();
    return ConcatenatingInsertAllResponse();
  }

  @override
  Future<ConcatenatingRemoveRangeResponse> concatenatingRemoveRange(
    ConcatenatingRemoveRangeRequest r,
  ) async {
    ids.removeRange(r.startIndex, r.endIndex);
    if (index >= r.endIndex) {
      index -= r.endIndex - r.startIndex;
    } else if (index >= r.startIndex) {
      index = r.startIndex;
    }
    _emit();
    return ConcatenatingRemoveRangeResponse();
  }

  @override
  Future<ConcatenatingMoveResponse> concatenatingMove(
    ConcatenatingMoveRequest r,
  ) async => ConcatenatingMoveResponse();

  /// The playing track reaches its end: moves to the preloaded one (gapless) or completes.
  void finishTrack() {
    if (index + 1 < ids.length) {
      index++;
      pos = Duration.zero;
    } else {
      state = ProcessingStateMessage.completed;
      playing = false;
      _playing?.complete();
      _playing = null;
    }
    _emit();
  }

  /// Moves the position (as if the track played up to [d]).
  void playedTo(Duration d) {
    pos = d;
    _emit();
  }

  @override
  Future<SetVolumeResponse> setVolume(SetVolumeRequest r) async =>
      SetVolumeResponse();
  @override
  Future<SetSpeedResponse> setSpeed(SetSpeedRequest r) async =>
      SetSpeedResponse();
  @override
  Future<SetLoopModeResponse> setLoopMode(SetLoopModeRequest r) async =>
      SetLoopModeResponse();
  @override
  Future<SetShuffleModeResponse> setShuffleMode(
    SetShuffleModeRequest r,
  ) async => SetShuffleModeResponse();
  @override
  Future<SetShuffleOrderResponse> setShuffleOrder(
    SetShuffleOrderRequest r,
  ) async => SetShuffleOrderResponse();
  @override
  Future<SetAndroidAudioAttributesResponse> setAndroidAudioAttributes(
    SetAndroidAudioAttributesRequest r,
  ) async => SetAndroidAudioAttributesResponse();
  @override
  Future<SetAutomaticallyWaitsToMinimizeStallingResponse>
  setAutomaticallyWaitsToMinimizeStalling(
    SetAutomaticallyWaitsToMinimizeStallingRequest r,
  ) async => SetAutomaticallyWaitsToMinimizeStallingResponse();
  @override
  Future<SetPitchResponse> setPitch(SetPitchRequest r) async =>
      SetPitchResponse();
  @override
  Future<SetSkipSilenceResponse> setSkipSilence(
    SetSkipSilenceRequest r,
  ) async => SetSkipSilenceResponse();
  @override
  Future<DisposeResponse> dispose(DisposeRequest r) async => DisposeResponse();
}

/// Jellyfin that answers everything with an empty list; InstantMix returns [mix].
class FakeJellyfinHttp implements HttpClientAdapter {
  List<Item> mix = const [];
  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    final items = o.path.contains('/InstantMix')
        ? [
            for (final t in mix)
              {
                'Id': t.id,
                'Name': t.name,
                'Type': 'Audio',
                'RunTimeTicks': 1800000000,
              },
          ]
        : const [];
    return ResponseBody.fromString(
      jsonEncode({'Items': items, 'TotalRecordCount': items.length}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class Rig {
  final ProviderContainer box;
  final FakeJustAudio platform;
  final FakeJellyfinHttp http;
  Rig(this.box, this.platform, this.http);

  PlayerController get player => box.read(playerProvider.notifier);
  QueueState get q => box.read(playerProvider);
  FakeAudio get audio => platform.last!;
  List<String> get ids => [for (final t in q.queue) t.id];
  String? get current => q.current?.id;

  /// Lets the player react (streams, the 300 ms preload timer).
  Future<void> settle([int ms = 450]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  /// Waits (up to 5 s) until [ok] holds: for steps that wait on the fake server.
  Future<void> until(bool Function() ok) async {
    for (var i = 0; i < 100 && !ok(); i++) {
      await settle(50);
    }
  }

  void dispose() => box.dispose();
}

/// A player with the given saved preferences (the same prefs object can make a "restarted app").
Future<Rig> makeRig({SharedPreferences? prefs, FakeJellyfinHttp? http}) async {
  if (prefs == null) {
    SharedPreferences.setMockInitialValues({'extrasUrl': ''});
    prefs = await SharedPreferences.getInstance();
  }
  final platform = FakeJustAudio();
  JustAudioPlatform.instance = platform;
  final h = http ?? FakeJellyfinHttp();
  final api = Jellyfin(
    baseUrl: 'http://jf.test',
    deviceId: 'dev',
    deviceName: 'test',
    token: 'tok',
    userId: 'me',
    adapter: h,
  );
  final box = ProviderContainer(
    overrides: [
      prefsProvider.overrideWithValue(prefs),
      apiProvider.overrideWithValue(api),
    ],
  );
  box.read(playerProvider);
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return Rig(box, platform, h);
}
