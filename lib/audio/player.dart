import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../api/catalog.dart';
import '../api/jellyfin.dart';
import '../api/models.dart';
import '../state/downloads.dart';
import '../state/library.dart';
import '../state/offline.dart';
import '../state/session.dart';
import '../api/response_cache.dart';
import 'media_session.dart';
import '../l10n/l10n.dart';

enum RepeatMode { off, all, one }

/// Queue index for the track the player is actually on ([playingId]), when the player moved on
/// to the preloaded track by itself and the queue did not follow; null when they already agree.
/// Without this the queue stayed on the old track and, when the new one ended, "next" played the
/// same track again (seen in Android Auto, build 13).
int? catchUpIndex(QueueState st, String? playingId) {
  if (playingId == null || playingId == st.current?.id) return null;
  if (playingId == st.next?.id) return st.index + 1;
  if (st.repeat == RepeatMode.all &&
      st.index == st.queue.length - 1 &&
      st.queue.length > 1 &&
      st.queue.first.id == playingId) {
    return 0;
  }
  return null;
}

/// Jam: on the guest, the buttons become requests to the host (returns true when handled).
typedef JamRemote = bool Function(
  String action, {
  int? index,
  List<Item>? items,
});

/// Another device playing in place of this one (Chromecast). The queue stays in the app; each
/// track is sent there by URL.
abstract class RemoteOutput {
  Future<void> load(
    Item item,
    String url,
    MediaItem meta, {
    required Duration at,
    required bool play,
  });
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration d);
  Future<void> setVolume(double v);
  bool get playing;
  Duration get position;
}

/// Queue state, Spotify style:
/// "Now playing", "Next in queue" (added manually) and "Next from: `<context>`".
class QueueState {
  final List<Item> queue;
  final int index;
  final int manualCount; // how many after the current one were added manually
  final String contextName;
  final String?
  contextRoute; // route of the playlist/album/artist that produced the queue
  final bool shuffle;
  final RepeatMode repeat;
  final bool playing;
  final bool buffering;

  /// Name of the device that is playing (Chromecast); empty = this device.
  final String castingTo;
  bool get casting => castingTo.isNotEmpty;

  /// Smart Shuffle: shuffle with recommendations mixed in (playlists only).
  final bool smart;

  /// Ids of the tracks Smart Shuffle added (shown with ✦ in the queue).
  final Set<String> recommended;

  const QueueState({
    this.queue = const [],
    this.index = -1,
    this.manualCount = 0,
    this.contextName = '',
    this.contextRoute,
    this.shuffle = false,
    this.repeat = RepeatMode.off,
    this.playing = false,
    this.buffering = false,
    this.castingTo = '',
    this.smart = false,
    this.recommended = const {},
  });

  /// Id of the playlist that produced the queue (null if it is not a playlist).
  String? get contextPlaylistId {
    final r = contextRoute ?? '';
    return r.startsWith('/playlist/') ? r.substring(10) : null;
  }

  Item? get current => index >= 0 && index < queue.length ? queue[index] : null;

  List<Item> get manualNext => queue.skip(index + 1).take(manualCount).toList();

  List<Item> get contextNext => queue.skip(index + 1 + manualCount).toList();

  Item? get next => index + 1 < queue.length ? queue[index + 1] : null;

  QueueState copyWith({
    List<Item>? queue,
    int? index,
    int? manualCount,
    String? contextName,
    String? contextRoute,
    bool? shuffle,
    RepeatMode? repeat,
    bool? playing,
    bool? buffering,
    String? castingTo,
    bool? smart,
    Set<String>? recommended,
  }) => QueueState(
    queue: queue ?? this.queue,
    index: index ?? this.index,
    manualCount: manualCount ?? this.manualCount,
    contextName: contextName ?? this.contextName,
    contextRoute: contextRoute ?? this.contextRoute,
    shuffle: shuffle ?? this.shuffle,
    repeat: repeat ?? this.repeat,
    playing: playing ?? this.playing,
    buffering: buffering ?? this.buffering,
    castingTo: castingTo ?? this.castingTo,
    smart: smart ?? this.smart,
    recommended: recommended ?? this.recommended,
  );
}

/// Whether a player state read from the panel should replace this device's paused queue: only
/// when it is newer than the last one this device sent or took, and came from another device.
bool takeOverCloudState({
  required int updated,
  required int seen,
  required Object? device,
  required String me,
}) => updated > seen && device != me;

class PlayerController extends Notifier<QueueState> {
  final AudioPlayer audio = AudioPlayer();
  final _subs = <StreamSubscription>[];
  Timer? _progressTimer;
  Item? _reported; // track Jellyfin knows is playing
  List<Item> _unshuffled = const [];
  bool autoplay = true;
  bool _sourceReady =
      false; // has the current track already been loaded into the player?
  Duration _resumeAt =
      Duration.zero; // position saved the last time the app closed
  Timer? _saveTimer;

  // Resume on another device: the queue goes to the panel and another device picks it up paused.
  int _cloudSeen =
      0; // panel stamp of the state this device already sent or took
  String? _pushedId; // track of the last state sent
  DateTime _pushedAt = DateTime(0);
  DateTime _pulledAt = DateTime(0);
  bool _pulling = false;
  int _loadEpoch =
      0; // bumps on every load: a pull that started before it gives up

  /// Jam (guest): next/previous/play/queue become requests to the host.
  JamRemote? remote;

  /// Chromecast: when on, the sound comes out there and this device's player stays stopped.
  RemoteOutput? _out;
  final _remotePos = StreamController<Duration>.broadcast();

  /// Position, playing state and duration of where the sound is coming out (here or on the Chromecast).
  Duration get position => _out?.position ?? audio.position;
  bool get isPlaying => _out?.playing ?? audio.playing;
  Duration? get duration =>
      _out == null ? audio.duration : state.current?.duration;
  Stream<Duration> get remotePositionStream => _remotePos.stream;

  // Last.fm: "now playing" and scrobble (half the track or 4 min).
  bool _npSent = false, _scrobbled = false;
  DateTime _startedAt = DateTime.now();

  // Gapless: the next track is already loaded in the player, right after the current one.
  String? _preId; // id of the track loaded after the current one (null = none)
  bool _busy = false; // swapping the player's tracks (not to be confused with an automatic advance)
  Timer? _syncSoon;

  // Volume: the slider's × the track's normalization × the sleep timer's fade.
  double _userVol = 0.8;
  double _fade = 1;
  final _volume = StreamController<double>.broadcast();

  /// Sleep timer "end of track": does not chain the next one and stops when this one ends.
  bool _stopAfterCurrent = false;
  void Function()? onSleepEnded;

  Jellyfin get _api => ref.read(apiProvider);

  /// Saves the episode's resume point to the panel (and in memory, to return to it without waiting for the panel).
  void _podcastSave(Item c) {
    final pos = position;
    podcastResume[c.id] = pos;
    final show = c.albumId ?? '';
    unawaited(
      ref
          .read(catalogProvider)
          .podcastProgress(
            c.id.substring(3),
            show.startsWith('podshow') ? show.substring(7) : '',
            pos,
            duration ?? c.duration,
          )
          .catchError((_) {}),
    );
  }

  @override
  QueueState build() {
    final prefs = ref.read(prefsProvider);
    _userVol = prefs.getDouble('volume') ?? 0.8;
    autoplay = prefs.getBool('autoplay') ?? true;
    _subs.add(audio.playerStateStream.listen(_onPlayerState));
    _subs.add(
      audio.positionDiscontinuityStream.listen((d) {
        if (d.reason == PositionDiscontinuityReason.autoAdvance) {
          unawaited(_autoAdvanced());
        }
      }),
    );
    // Second signal for the same thing: the discontinuity event alone was missed at times, leaving
    // the queue one track behind the player.
    _subs.add(
      audio.currentIndexStream.listen((i) {
        if (i != null && i > 0) unawaited(_autoAdvanced());
      }),
    );
    // What comes after the current one changed (queue, shuffle, repeat): swaps the preloaded track.
    listenSelf((prev, next) {
      if (prev?.next?.id != next.next?.id ||
          prev?.repeat != next.repeat ||
          prev?.index != next.index ||
          (next.index == next.queue.length - 1 &&
              prev?.queue.firstOrNull?.id != next.queue.firstOrNull?.id)) {
        _scheduleSync();
      }
      MediaSession.instance?.update(prev, next);
    });
    // Only after build() returns: attach reads the queue, and reading state inside build throws
    // ("uninitialized provider"), which left the whole phone screen gray.
    Future.microtask(() {
      if (ref.mounted) MediaSession.instance?.attach(this);
    });
    // Saves the resume point every 5 s while playing (closing the app loses at most that).
    _saveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (isPlaying) {
        _save();
        _scrobbleTick();
        // The panel gets it on every track change and every ~15 s while playing.
        if (state.current?.id != _pushedId ||
            DateTime.now().difference(_pushedAt) >=
                const Duration(seconds: 15)) {
          unawaited(_pushCloud());
        }
      }
    });
    _cloudSeen = prefs.getInt(_seenKey) ?? 0;
    // Opening the app (or Android Auto starting it) and coming back to it: picks up what another
    // device was playing, if nothing is playing here.
    Future.microtask(() {
      if (ref.mounted) unawaited(syncFromCloud());
    });
    final life = AppLifecycleListener(
      onResume: () => unawaited(syncFromCloud()),
    );
    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _progressTimer?.cancel();
      _saveTimer?.cancel();
      life.dispose();
      _syncSoon?.cancel();
      _volume.close();
      _remotePos.close();
      audio.dispose();
    });
    return _restore(prefs.getString(_saveKey));
  }

  // ---------- remember where it stopped ----------

  static const _saveKey = 'lastQueue';

  static const _seenKey = 'cloudStateSeen';

  /// Queue, current track, position, shuffle and repeat: the app opens paused at the same place.
  void _save() {
    final prefs = ref.read(prefsProvider);
    final snap = _snapshot();
    if (snap == null) {
      prefs.remove(_saveKey);
    } else {
      prefs.setString(_saveKey, jsonEncode(snap));
    }
  }

  /// Random id of this install, so a device does not take back its own state.
  String get _deviceId {
    final prefs = ref.read(prefsProvider);
    var id = prefs.getString('deviceId');
    if (id == null) {
      final r = Random.secure();
      id = [
        for (var i = 0; i < 16; i++)
          r.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ].join();
      prefs.setString('deviceId', id);
    }
    return id;
  }

  /// What is saved locally and sent to the panel (null = nothing in the queue).
  Map<String, dynamic>? _snapshot() {
    final st = state;
    if (st.current == null) return null;
    // Saves up to 300 tracks around the current one (radio queues can grow a lot).
    final from = max(0, st.index - 50);
    final items = st.queue.skip(from).take(300).toList();
    final pos = _sourceReady ? position : _resumeAt;
    return {
      'q': [for (final t in items) t.toStore()],
      'i': st.index - from,
      'm': st.manualCount,
      'cn': st.contextName,
      'cr': ?st.contextRoute,
      'sh': st.shuffle,
      'rp': st.repeat.index,
      'p': pos.inMilliseconds,
      if (st.smart) 'sm': true,
      if (st.recommended.isNotEmpty) 'rec': st.recommended.toList(),
    };
  }

  /// Sends the queue and position to the panel, for another device to resume from.
  Future<void> _pushCloud() async {
    if (remote != null) return; // Jam guest: the queue is the host's
    final snap = _snapshot();
    if (snap == null) return;
    final cat = ref.read(catalogProvider);
    if (!cat.enabled || cat.token.isEmpty) return;
    _pushedId = state.current?.id;
    _pushedAt = DateTime.now();
    try {
      final up = await cat.putPlayerState({...snap, 'dev': _deviceId});
      if (up > 0 && ref.mounted) {
        _cloudSeen = up;
        ref.read(prefsProvider).setInt(_seenKey, up);
      }
    } catch (e) {
      debugPrint('resume: send failed: $e');
    }
  }

  /// Takes over the queue another device of this account played last, paused at the same point.
  /// Never touches a queue that is playing here, a Jam or a Chromecast.
  Future<void> syncFromCloud() async {
    if (_pulling || remote != null || _out != null || isPlaying) return;
    if (DateTime.now().difference(_pulledAt) < const Duration(seconds: 20)) {
      return;
    }
    _pulling = true;
    final epoch = _loadEpoch;
    try {
      if (await apiReady() == null || !ref.mounted) return;
      final cat = ref.read(catalogProvider);
      if (!cat.enabled || cat.token.isEmpty) return;
      _pulledAt = DateTime.now();
      final j = await cat.playerState();
      final up = (j['updated'] as num?)?.toInt() ?? 0;
      if (!ref.mounted) return;
      if (!takeOverCloudState(
        updated: up,
        seen: _cloudSeen,
        device: j['dev'],
        me: _deviceId,
      )) {
        return;
      }
      // Something started here meanwhile: this device's queue wins.
      if (isPlaying ||
          _busy ||
          remote != null ||
          _out != null ||
          epoch != _loadEpoch) {
        return;
      }
      final next = _restore(jsonEncode(j));
      if (next.current == null) return;
      _cloudSeen = up;
      ref.read(prefsProvider).setInt(_seenKey, up);
      await _reportStop();
      _progressTimer?.cancel();
      if (_sourceReady) await audio.stop();
      _sourceReady = false;
      _preId = null;
      state = next;
      _save();
      debugPrint(
        'resume: took the queue from another device (${next.queue.length} tracks)',
      );
    } catch (e) {
      debugPrint('resume: read failed: $e');
    } finally {
      _pulling = false;
    }
  }

  QueueState _restore(String? raw) {
    if (raw == null) return const QueueState();
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final q = [
        for (final x in (j['q'] as List? ?? const []))
          Item.fromStore(x as Map<String, dynamic>),
      ];
      final i = j['i'] as int? ?? 0;
      if (q.isEmpty || i < 0 || i >= q.length) return const QueueState();
      _resumeAt = Duration(milliseconds: j['p'] as int? ?? 0);
      _unshuffled = q;
      return QueueState(
        queue: q,
        index: i,
        manualCount: j['m'] as int? ?? 0,
        contextName: j['cn'] as String? ?? '',
        contextRoute: j['cr'] as String?,
        shuffle: j['sh'] == true,
        repeat: RepeatMode.values[(j['rp'] as int? ?? 0).clamp(0, 2)],
        smart: j['sm'] == true,
        recommended: {for (final x in (j['rec'] as List? ?? const [])) '$x'},
      );
    } catch (_) {
      return const QueueState(); // old or corrupted format: starts empty
    }
  }

  /// Saved position, shown before the track is loaded (the bar does not start at 0:00).
  Duration? get pendingPosition => _sourceReady ? null : _resumeAt;

  bool get sourceReady => _sourceReady;

  /// Current queue (for the media session, outside Riverpod).
  QueueState get queue => state;

  /// Jellyfin client as soon as the session is ready (Android Auto can open before the UI).
  Future<Jellyfin?> apiReady() async {
    try {
      return (await ref.read(sessionProvider.future))?.api;
    } catch (_) {
      return null;
    }
  }

  /// Tracks downloaded on the device (for Android Auto).
  List<Item> offlineTracks() =>
      ref.read(offlineProvider).tracks.values.toList();

  void _onPlayerState(PlayerState s) {
    // playing on the Chromecast: this device's player is stopped
    if (_out != null) return;
    final buffering =
        s.processingState == ProcessingState.loading ||
        s.processingState == ProcessingState.buffering;
    if (s.playing != state.playing || buffering != state.buffering) {
      if (s.playing != state.playing) _save();
      if (!s.playing && state.playing && _sourceReady) unawaited(_pushCloud());
      state = state.copyWith(playing: s.playing, buffering: buffering);
      final cur = state.current;
      if (cur != null && _reported?.id == cur.id) {
        _api.reportProgress(cur.id, audio.position, paused: !s.playing);
      }
    }
    if (s.processingState == ProcessingState.completed) {
      final c = state.current;
      if (c != null && c.isPodcast) _podcastSave(c);
      _onTrackEnded();
    }
  }

  Future<void> _onTrackEnded() async {
    // Jam: the host is the one who advances to the next track
    if (remote != null) return;
    // The player had already moved on to the preloaded track without the queue noticing, and that
    // track is the one that just ended: catch the queue up first so "next" does not replay it.
    if (_out == null) {
      final i = audio.currentIndex;
      final seq = audio.sequence;
      final tag = i != null && i < seq.length ? seq[i].tag : null;
      final to = tag is Item ? catchUpIndex(state, tag.id) : null;
      if (to != null) {
        state = state.copyWith(
          index: to,
          manualCount: to == 0 ? 0 : max(0, state.manualCount - 1),
        );
      }
    }
    if (_stopAfterCurrent) {
      // Sleep timer "end of track": leaves the next one ready, but stopped.
      _stopAfterCurrent = false;
      onSleepEnded?.call();
      if (state.index + 1 < state.queue.length) {
        state = state.copyWith(
          index: state.index + 1,
          manualCount: max(0, state.manualCount - 1),
        );
        await _load(play: false);
      } else {
        await _pauseAt(Duration.zero);
      }
      return;
    }
    if (state.repeat == RepeatMode.one) {
      if (_out != null) {
        await _load(play: true, at: Duration.zero);
        return;
      }
      await audio.seek(Duration.zero);
      await audio.play();
      return;
    }
    await next();
  }

  // ---------- play ----------

  /// Plays [tracks] starting at [start]. [contextName] appears in the queue as
  /// "Next from: ...".
  Future<void> playList(
    List<Item> tracks, {
    int start = 0,
    String contextName = '',
    String? contextRoute,
    bool? shuffle,
  }) async {
    if (tracks.isEmpty) return;
    // Jam (guest): choosing a track asks for it to join everyone's queue.
    if (remote?.call(
          'add',
          items: [tracks[start.clamp(0, tracks.length - 1)]],
        ) ??
        false) {
      return;
    }
    final sh = shuffle ?? state.shuffle;
    var list = List<Item>.of(tracks);
    var idx = start.clamp(0, list.length - 1);
    _unshuffled = List.of(list);
    if (sh) {
      final first = list.removeAt(idx);
      list.shuffle(Random());
      list.insert(0, first);
      idx = 0;
    }
    state = state.copyWith(
      queue: list,
      index: idx,
      manualCount: 0,
      contextName: contextName,
      contextRoute: contextRoute,
      shuffle: sh,
      smart: false,
      recommended: const {},
    );
    await _load(play: true);
  }

  /// Smart Shuffle straight from the playlist page.
  Future<void> smartShufflePlay(
    List<Item> tracks, {
    String contextName = '',
    String? contextRoute,
  }) async {
    await shufflePlay(
      tracks,
      contextName: contextName,
      contextRoute: contextRoute,
    );
    if (remote != null || state.current == null) return;
    state = state.copyWith(smart: true);
    await _addRecommendations();
  }

  /// Places a recommendation every 3 tracks of what comes next (Instant Mix from a few of the playlist's).
  Future<void> _addRecommendations() async {
    final ctx = state.contextNext
        .where((t) => !t.isCatalog && !t.isPodcast)
        .toList();
    final have = state.queue.map((t) => t.id).toSet();
    final seeds = List.of(ctx.isEmpty ? [state.current!] : ctx)
      ..shuffle(Random());
    final recs = <Item>[];
    for (final s in seeds.take(4)) {
      try {
        for (final t in await _api.instantMix(s.id, limit: 25)) {
          if (!have.contains(t.id) && !recs.any((r) => r.id == t.id)) {
            recs.add(t);
          }
        }
      } catch (_) {}
    }
    if (!state.smart || recs.isEmpty) return; // turned off while fetching
    recs.shuffle(Random());
    final headLen = state.index + 1 + state.manualCount;
    final head = state.queue.take(headLen).toList();
    final rest = state.queue.skip(headLen).toList();
    final want = min(recs.length, max(3, rest.length ~/ 3)).clamp(0, 40);
    final out = <Item>[];
    var ri = 0;
    for (var i = 0; i < rest.length; i++) {
      out.add(rest[i]);
      if ((i + 1) % 3 == 0 && ri < want) out.add(recs[ri++]);
    }
    while (ri < min(want, 3)) {
      out.add(recs[ri++]); // short playlist: at least a few recommendations
    }
    state = state.copyWith(
      queue: [...head, ...out],
      recommended: {...state.recommended, for (final r in recs.take(ri)) r.id},
    );
    _save();
  }

  /// Accepted recommendation (went to the playlist): loses the ✦.
  void acceptRecommendation(String id) {
    state = state.copyWith(recommended: {...state.recommended}..remove(id));
  }

  // ---------- Jam (guest) ----------

  /// Loads the host's queue already at the host's track and position.
  Future<void> jamLoad(
    List<Item> q,
    int index,
    Duration at,
    bool play,
    String context,
  ) async {
    state = state.copyWith(
      queue: List.of(q),
      index: index,
      manualCount: 0,
      contextName: context.isEmpty ? 'Jam' : 'Jam · $context',
      shuffle: false,
      smart: false,
      recommended: const {},
    );
    await _load(play: play, at: at);
  }

  /// The host's queue changed, but the track is the same: just swaps the list.
  void jamQueue(List<Item> q, int index, String context) {
    state = state.copyWith(
      queue: List.of(q),
      index: index,
      manualCount: 0,
      contextName: context.isEmpty ? 'Jam' : 'Jam · $context',
    );
  }

  Future<void> jamPlaying(bool play) async {
    if (!_sourceReady) {
      if (play) await _load(play: true);
      return;
    }
    if (play) {
      await audio.play();
    } else {
      await audio.pause();
    }
  }

  // ---------- Last.fm ----------

  bool get _lastfmOn => ref.read(prefsProvider).getBool('lastfm') ?? false;

  void _scrobbleTick() {
    final c = state.current;
    if (c == null || c.isPodcast || !_lastfmOn || !_sourceReady) return;
    final cat = ref.read(catalogProvider);
    if (!_npSent) {
      _npSent = true;
      unawaited(cat.scrobble(c, nowPlaying: true).catchError((_) {}));
    }
    final dur = duration ?? c.duration;
    if (_scrobbled || dur < const Duration(seconds: 30)) return;
    final need = Duration(milliseconds: min(dur.inMilliseconds ~/ 2, 240000));
    if (position >= need) {
      _scrobbled = true;
      unawaited(
        cat.scrobble(c, nowPlaying: false, at: _startedAt).catchError((_) {}),
      );
    }
  }

  /// Plays a list starting at a random track with shuffle on.
  Future<void> shufflePlay(
    List<Item> tracks, {
    String contextName = '',
    String? contextRoute,
  }) {
    if (tracks.isEmpty) return Future.value();
    return playList(
      tracks,
      start: Random().nextInt(tracks.length),
      contextName: contextName,
      contextRoute: contextRoute,
      shuffle: true,
    );
  }

  /// Where to play [t] from: downloaded file, podcast, catalog or Jellyfin (original or converted).
  /// null = no internet and the track is not on the device.
  Future<AudioSource?> _sourceFor(Item t) async {
    final dz = t.isCatalog ? t.deezerId : null;
    final direct = t.streamUrl;
    // Downloaded on the device: plays from the file (works without internet).
    final local = dz == null && direct == null
        ? ref.read(offlineProvider.notifier).audioPath(t.id)
        : null;
    if (local != null) return AudioSource.file(local, tag: t);
    if (ResponseCache.instance?.offline.value ?? false) return null;
    if (direct != null) return AudioSource.uri(Uri.parse(direct), tag: t);
    // Catalog track: the panel finds it on YouTube Music and serves the audio (and already requests the download).
    if (dz != null) {
      final cat = ref.read(catalogProvider);
      return AudioSource.uri(
        Uri.parse(cat.playUrl(dz)),
        headers: cat.headers,
        tag: t,
      );
    }
    final kbps = await _qualityKbps();
    if (kbps > 0) {
      return HlsAudioSource(
        Uri.parse(_api.transcodeUrl(t.id, kbps)),
        tag: t,
        duration: t.duration == Duration.zero ? null : t.duration,
      );
    }
    return AudioSource.uri(Uri.parse(_api.streamUrl(t.id)), tag: t);
  }

  /// Quality chosen for the current connection (0 = original file).
  Future<int> _qualityKbps() async {
    final p = ref.read(prefsProvider);
    if (!(Platform.isAndroid || Platform.isIOS)) return p.getInt('qWifi') ?? 0;
    try {
      final c = await Connectivity().checkConnectivity();
      final mobile =
          c.contains(ConnectivityResult.mobile) &&
          !c.contains(ConnectivityResult.wifi) &&
          !c.contains(ConnectivityResult.ethernet);
      return p.getInt(mobile ? 'qMobile' : 'qWifi') ?? 0;
    } catch (_) {
      return p.getInt('qWifi') ?? 0;
    }
  }

  /// Track that should be preloaded after the current one (gapless), or null.
  Item? _desiredNext() {
    final st = state;
    final cur = st.current;
    if (cur == null ||
        cur.isPodcast ||
        remote != null ||
        _out != null ||
        _stopAfterCurrent ||
        st.repeat == RepeatMode.one) {
      return null;
    }
    final n =
        st.next ??
        (st.repeat == RepeatMode.all && st.queue.length > 1
            ? st.queue.first
            : null);
    return n == null || n.isPodcast ? null : n;
  }

  Future<void> _load({required bool play, Duration? at}) async {
    final cur = state.current;
    if (cur == null) return;
    _loadEpoch++;
    _sourceReady = false;
    _busy = true;
    _preId = null;
    try {
      await _reportStop();
      final out = _out;
      if (out != null) {
        final at0 =
            at ?? (cur.streamUrl != null ? podcastResume[cur.id] : null);
        await out.load(
          cur,
          _castUrl(cur),
          mediaItemOf(cur),
          at: at0 ?? Duration.zero,
          play: play,
        );
        _sourceReady = true;
        _resumeAt = Duration.zero;
        _started(cur, play: play, at: at0 ?? Duration.zero);
        return;
      }
      final src = await _sourceFor(cur);
      if (src == null) {
        // No internet: skips straight to the next track downloaded on the device.
        final off = ref.read(offlineProvider);
        for (var j = state.index + 1; j < state.queue.length; j++) {
          if (off.has(state.queue[j].id)) {
            state = state.copyWith(
              index: j,
              manualCount: max(0, state.manualCount - (j - state.index)),
            );
            _busy = false;
            await _load(play: play);
            return;
          }
        }
        // Nothing downloaded after this one: stays stopped on it.
        await audio.stop();
        return;
      }
      final nextItem = _desiredNext();
      AudioSource? nextSrc;
      if (nextItem != null) {
        try {
          nextSrc = await _sourceFor(nextItem);
        } catch (_) {}
      }
      if (state.current?.id != cur.id) {
        return; // the track changed while preparing
      }
      await audio.setAudioSources(
        [src, ?nextSrc],
        initialIndex: 0,
        initialPosition:
            at ?? (cur.streamUrl != null ? podcastResume[cur.id] : null),
      );
      _preId = nextSrc == null ? null : nextItem!.id;
      _sourceReady = true;
      _resumeAt = Duration.zero;
      _started(cur, play: play, at: at ?? Duration.zero);
      if (play) unawaited(audio.play());
      _scheduleSync(); // the queue may have changed while loading
    } catch (_) {
      // Problematic file: skips to the next one.
      if (state.index + 1 < state.queue.length) {
        state = state.copyWith(
          index: state.index + 1,
          manualCount: max(0, state.manualCount - 1),
        );
        _busy = false;
        await _load(play: play);
      }
    } finally {
      _busy = false;
    }
  }

  /// Started playing [cur] (loaded now or chained without a gap): volume, speed,
  /// scrobble, "remember where it stopped" and the report to Jellyfin.
  void _started(Item cur, {required bool play, required Duration at}) {
    _npSent = false;
    _scrobbled = false;
    _startedAt = DateTime.now();
    _applyVolume();
    if (_out == null) {
      unawaited(audio.setSpeed(cur.isPodcast ? podcastSpeed : 1.0));
    }
    _save();
    _progressTimer?.cancel();
    if (cur.streamUrl != null) {
      // Podcast: saves the resume point to the panel (continues from the same point on the other device).
      _progressTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        final c = state.current;
        if (c != null && c.isPodcast && isPlaying) _podcastSave(c);
      });
      return;
    }
    if (cur.isCatalog && cur.deezerId != null) {
      ref.read(downloadsProvider.notifier).refreshSoon();
      return; // Jellyfin does not know this track: nothing to report
    }
    _reported = cur;
    _api.reportStart(cur.id, at, paused: !play);
    _progressTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final c = state.current;
      if (c != null && isPlaying) {
        _api.reportProgress(c.id, position, paused: false);
      }
    });
  }

  /// The player moved on by itself to the preloaded track (no gap between the two).
  Future<void> _autoAdvanced([int tries = 0]) async {
    if (_busy) {
      // Busy preparing the next track (e.g. the queue just changed): try again shortly instead of
      // dropping the advance, which left the queue, the notification and Android Auto on the old track.
      if (tries < 20) {
        Timer(
          const Duration(milliseconds: 250),
          () => unawaited(_autoAdvanced(tries + 1)),
        );
      }
      return;
    }
    final i = audio.currentIndex;
    final seq = audio.sequence;
    if (i == null || i >= seq.length) return;
    final tag = seq[i].tag;
    if (tag is! Item) return;
    // Normally the preloaded track; also accepts the queue's next one in case _preId went stale.
    if (tag.id != _preId && catchUpIndex(state, tag.id) == null) return;
    await _advanced(tag.id);
  }

  /// The preloaded track ([id]) became the current one: fixes the queue and removes the previous one from the player.
  Future<void> _advanced(String id) async {
    final st = state;
    final r = _reported;
    if (r != null) {
      _reported = null;
      unawaited(_api.reportStopped(r.id, r.duration));
    }
    if (st.next?.id == id) {
      state = st.copyWith(
        index: st.index + 1,
        manualCount: max(0, st.manualCount - 1),
      );
    } else if (st.repeat == RepeatMode.all &&
        st.queue.isNotEmpty &&
        st.queue.first.id == id) {
      state = st.copyWith(index: 0, manualCount: 0);
    } else {
      _preId = null;
      return;
    }
    _preId = null;
    _started(state.current!, play: true, at: Duration.zero);
    _busy = true;
    try {
      while ((audio.currentIndex ?? 0) > 0) {
        await audio.removeAudioSourceAt(0);
      }
    } catch (_) {
    } finally {
      _busy = false;
    }
    _scheduleSync();
  }

  void _scheduleSync() {
    _syncSoon?.cancel();
    _syncSoon = Timer(
      const Duration(milliseconds: 300),
      () => unawaited(_syncNext()),
    );
  }

  /// Leaves the right track loaded after the current one (the queue may have changed).
  Future<void> _syncNext() async {
    if (_busy || !_sourceReady) return;
    final want = _desiredNext();
    final ci = audio.currentIndex ?? 0;
    final len = audio.sequence.length;
    if (want?.id == _preId && len == ci + (_preId == null ? 1 : 2)) return;
    _busy = true;
    try {
      if (len > ci + 1) await audio.removeAudioSourceRange(ci + 1, len);
      _preId = null;
      if (want != null) {
        final src = await _sourceFor(want);
        if (src != null && _desiredNext()?.id == want.id) {
          await audio.addAudioSource(src);
          _preId = want.id;
        }
      }
    } catch (_) {
      // no preloading: the next one loads when this one ends
    } finally {
      _busy = false;
    }
  }

  // ---------- volume, normalization, speed and timer ----------

  /// Slider volume (without normalization), for the on-screen controls.
  Stream<double> get volumeStream async* {
    yield _userVol;
    yield* _volume.stream;
  }

  double get volume => _userVol;

  bool get normalize => ref.read(prefsProvider).getBool('normalize') ?? true;

  void setNormalize(bool v) {
    ref.read(prefsProvider).setBool('normalize', v);
    _applyVolume();
  }

  /// How much to lower this track's volume so all of them match (Jellyfin analysis).
  /// A track without analysis uses a typical value, so it does not end up louder than the others.
  double get _gain {
    final c = state.current;
    if (!normalize || c == null || c.isPodcast) return 1;
    return pow(10, (c.normalizationGain ?? -7) / 20).toDouble();
  }

  void _applyVolume() {
    // on the Chromecast, only when the user changes it
    if (_out != null) return;
    unawaited(audio.setVolume((_userVol * _gain * _fade).clamp(0.0, 1.0)));
  }

  /// Sleep timer: 1 = normal, 0 = muted (fades down over the last seconds).
  set fade(double f) {
    _fade = f.clamp(0.0, 1.0);
    _applyVolume();
    final out = _out;
    if (out != null && _fade < 1) unawaited(out.setVolume(_userVol * _fade));
  }

  /// "End of track" timer: the next one does not chain and the player stops when this one ends.
  set stopAfterCurrent(bool v) {
    _stopAfterCurrent = v;
    _scheduleSync();
  }

  double get podcastSpeed =>
      ref.read(prefsProvider).getDouble('podSpeed') ?? 1.0;

  /// Podcast speed (music always plays at 1×).
  void setPodcastSpeed(double v) {
    ref.read(prefsProvider).setDouble('podSpeed', v);
    if (state.current?.isPodcast ?? false) unawaited(audio.setSpeed(v));
  }

  Future<void> pause() async {
    if (!isPlaying) return;
    if (remote?.call('toggle') ?? false) return;
    final out = _out;
    if (out != null) {
      await out.pause();
    } else {
      await audio.pause();
    }
    final c = state.current;
    if (c != null && c.isPodcast) _podcastSave(c);
  }

  /// Track data for the notification, lock screen and Android Auto.
  MediaItem mediaItemOf(Item t, {Duration? duration}) {
    final art = _api.imageUrl(t.imageItemId, size: 512);
    final d = duration ?? t.duration;
    return MediaItem(
      id: t.id,
      title: t.name,
      artist: t.artistLine,
      album: t.album,
      duration: d == Duration.zero ? null : d,
      artUri: art == null ? null : Uri.parse(art),
    );
  }

  Future<void> _reportStop() async {
    final r = _reported;
    if (r != null) {
      _reported = null;
      await _api.reportStopped(r.id, position);
    }
  }

  Future<void> togglePlay() async {
    if (state.current == null) return;
    if (remote?.call('toggle') ?? false) return;
    if (!_sourceReady) {
      // Queue saved last time: loads now and continues from where it stopped.
      await _load(play: true, at: _resumeAt);
      return;
    }
    final out = _out;
    if (isPlaying) {
      await pause();
    } else if (out != null) {
      await out.play();
    } else {
      await audio.play();
    }
  }

  Future<void> next() async {
    if (remote?.call('next') ?? false) return;
    final pre = _preId;
    if (pre != null &&
        !_busy &&
        audio.sequence.length > (audio.currentIndex ?? 0) + 1 &&
        (state.next?.id == pre || state.next == null)) {
      // Already loaded: just switches to it.
      _busy = true;
      try {
        await audio.seek(Duration.zero, index: (audio.currentIndex ?? 0) + 1);
      } finally {
        _busy = false;
      }
      await _advanced(pre);
      if (!audio.playing) unawaited(audio.play());
      return;
    }
    if (state.index + 1 < state.queue.length) {
      state = state.copyWith(
        index: state.index + 1,
        manualCount: max(0, state.manualCount - 1),
      );
      await _load(play: true);
      return;
    }
    if (state.repeat == RepeatMode.all && state.queue.isNotEmpty) {
      state = state.copyWith(index: 0, manualCount: 0);
      await _load(play: true);
      return;
    }
    if (autoplay && state.current != null) {
      final added = await _autoplayMore();
      if (added) {
        state = state.copyWith(index: state.index + 1);
        await _load(play: true);
        return;
      }
    }
    await _pauseAt(Duration.zero);
  }

  /// Pauses at point [d] (here or on the Chromecast).
  Future<void> _pauseAt(Duration d) async {
    final out = _out;
    if (out != null) {
      await out.pause();
      await out.seek(d);
      return;
    }
    await audio.pause();
    await audio.seek(d);
  }

  /// When the queue ends, continues with the Instant Mix of the last track.
  Future<bool> _autoplayMore() async {
    try {
      final seen = state.queue.map((t) => t.id).toSet();
      final mix = (await _api.instantMix(state.current!.id))
          .where((t) => !seen.contains(t.id))
          .toList();
      if (mix.isEmpty) return false;
      state = state.copyWith(
        queue: [...state.queue, ...mix],
        contextName: appL10n.audioRadioContext(state.current!.name),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> previous() async {
    if (remote?.call('previous') ?? false) return;
    if (position > const Duration(seconds: 3) || state.index <= 0) {
      await seek(Duration.zero);
      return;
    }
    state = state.copyWith(index: state.index - 1, manualCount: 0);
    await _load(play: true);
  }

  Future<void> jumpTo(int queueIndex) async {
    if (queueIndex < 0 || queueIndex >= state.queue.length) return;
    if (remote?.call('jump', index: queueIndex) ?? false) return;
    final consumed = queueIndex - state.index - 1;
    state = state.copyWith(
      index: queueIndex,
      manualCount: max(0, state.manualCount - max(0, consumed + 1)),
    );
    await _load(play: true);
  }

  Future<void> seek(Duration d) async {
    if (!_sourceReady) {
      // Saved queue not yet loaded: loads paused already at the chosen position.
      if (state.current != null) await _load(play: false, at: d);
      return;
    }
    final out = _out;
    if (out != null) {
      await out.seek(d);
      return;
    }
    await audio.seek(d);
  }

  Future<void> setVolume(double v) async {
    _userVol = v;
    _volume.add(v);
    _applyVolume();
    final out = _out;
    if (out != null) unawaited(out.setVolume(v * _fade));
    ref.read(prefsProvider).setDouble('volume', v);
  }

  // ---------- Chromecast ----------

  /// URL the Chromecast downloads on its own (without the app's headers).
  String _castUrl(Item t) {
    final direct = t.streamUrl;
    if (direct != null) return direct; // podcast
    final dz = t.isCatalog ? t.deezerId : null;
    if (dz != null) return ref.read(catalogProvider).playUrl(dz);
    return _api.castUrl(t.id);
  }

  /// Turns the Chromecast on ([out]) or off (null). When turning on, continues from where it was,
  /// playing if it was playing; when turning off, comes back here paused at [at].
  Future<void> setOutput(
    RemoteOutput? out, {
    String name = '',
    Duration? at,
  }) async {
    final pos = at ?? position;
    final wasPlaying = isPlaying;
    if (out != null) {
      await audio.pause();
      _out = out;
      state = state.copyWith(castingTo: name, buffering: false);
      if (state.current != null) await _load(play: wasPlaying, at: pos);
      return;
    }
    if (_out == null) return;
    _out = null;
    state = state.copyWith(castingTo: '', playing: false, buffering: false);
    if (state.current != null) await _load(play: false, at: pos);
  }

  /// The Chromecast reported that it is playing/paused/loading.
  void remoteStatus({required bool playing, required bool buffering}) {
    if (_out == null) return;
    if (playing == state.playing && buffering == state.buffering) return;
    if (playing != state.playing) _save();
    if (!playing && state.playing) unawaited(_pushCloud());
    state = state.copyWith(playing: playing, buffering: buffering);
    final cur = state.current;
    if (cur != null && _reported?.id == cur.id) {
      _api.reportProgress(cur.id, position, paused: !playing);
    }
  }

  /// Estimated Chromecast position (the progress bar moves with it).
  void remotePosition(Duration p) {
    if (_out != null && !_remotePos.isClosed) _remotePos.add(p);
  }

  /// The track ended on the Chromecast.
  void remoteEnded() {
    if (_out == null) return;
    final c = state.current;
    if (c != null && c.isPodcast) _podcastSave(c);
    unawaited(_onTrackEnded());
  }

  // ---------- queue ----------

  /// "Add to queue": goes after the ones already added manually.
  void addToQueue(List<Item> tracks) {
    if (tracks.isEmpty) return;
    if (remote?.call('add', items: tracks) ?? false) return;
    if (state.current == null) {
      playList(tracks, contextName: appL10n.commonQueue);
      return;
    }
    final q = List<Item>.of(state.queue);
    q.insertAll(state.index + 1 + state.manualCount, tracks);
    state = state.copyWith(
      queue: q,
      manualCount: state.manualCount + tracks.length,
    );
  }

  /// "Play next": right after the current one.
  void playNext(List<Item> tracks) {
    if (remote?.call('add', items: tracks) ?? false) return;
    if (state.current == null) {
      playList(tracks, contextName: appL10n.commonQueue);
      return;
    }
    final q = List<Item>.of(state.queue)..insertAll(state.index + 1, tracks);
    state = state.copyWith(
      queue: q,
      manualCount: state.manualCount + tracks.length,
    );
  }

  void removeAt(int queueIndex) {
    if (queueIndex <= state.index || queueIndex >= state.queue.length) return;
    final q = List<Item>.of(state.queue)..removeAt(queueIndex);
    final wasManual = queueIndex <= state.index + state.manualCount;
    state = state.copyWith(
      queue: q,
      manualCount: wasManual ? state.manualCount - 1 : state.manualCount,
    );
  }

  /// Reorders within what comes after the current one ([from]/[to] are queue indices).
  void move(int from, int to) {
    if (from <= state.index || to <= state.index) return;
    final q = List<Item>.of(state.queue);
    final t = q.removeAt(from);
    q.insert(to > from ? to - 1 : to, t);
    state = state.copyWith(queue: q);
  }

  /// Shuffle → Smart Shuffle (in a playlist) → off.
  void toggleShuffle() {
    final cur = state.current;
    if (cur == null) {
      state = state.copyWith(shuffle: !state.shuffle);
      return;
    }
    if (state.shuffle &&
        !state.smart &&
        state.contextPlaylistId != null &&
        remote == null) {
      state = state.copyWith(smart: true);
      unawaited(_addRecommendations());
      return;
    }
    if (state.smart) {
      // Turns everything off: recommendations that have not played yet leave the queue.
      final keep = state.index + 1 + state.manualCount;
      state = state.copyWith(
        queue: [
          ...state.queue.take(keep),
          ...state.queue
              .skip(keep)
              .where((t) => !state.recommended.contains(t.id)),
        ],
        smart: false,
        recommended: const {},
      );
    }
    final head = state.queue.take(state.index + 1 + state.manualCount).toList();
    if (!state.shuffle) {
      _unshuffled = List.of(state.queue);
      final rest = state.queue.skip(head.length).toList()..shuffle(Random());
      state = state.copyWith(queue: [...head, ...rest], shuffle: true);
    } else {
      // Returns to the original order starting from the current track.
      final pos = _unshuffled.indexWhere((t) => t.id == cur.id);
      final headIds = head.map((t) => t.id).toSet();
      final rest = (pos >= 0 ? _unshuffled.skip(pos + 1) : _unshuffled)
          .where((t) => !headIds.contains(t.id))
          .toList();
      state = state.copyWith(queue: [...head, ...rest], shuffle: false);
    }
  }

  /// Likes or unlikes the playing track (car and notification button).
  Future<void> toggleCurrentFavorite() async {
    final cur = state.current;
    if (cur == null || cur.isCatalog) return;
    final fav = !cur.favorite;
    await _api.setFavorite(cur.id, fav);
    updateItem(cur.copyWith(favorite: fav));
    ref.invalidate(libraryProvider);
    ref.invalidate(likedTracksProvider);
  }

  void cycleRepeat() {
    final next = RepeatMode.values[(state.repeat.index + 1) % 3];
    state = state.copyWith(repeat: next);
  }

  void setAutoplay(bool v) {
    autoplay = v;
    ref.read(prefsProvider).setBool('autoplay', v);
  }

  /// Updates the track's favorite flag everywhere in the queue.
  void updateItem(Item item) {
    state = state.copyWith(
      queue: [for (final t in state.queue) t.id == item.id ? item : t],
    );
  }

  Future<void> stop() async {
    await _reportStop();
    _progressTimer?.cancel();
    await audio.stop();
    _sourceReady = false;
    _preId = null;
    state = const QueueState();
    _save();
  }
}

/// Resume point of each podcast episode (id "pod…"), coming from the panel when the podcast page opens.
final podcastResume = <String, Duration>{};

final playerProvider = NotifierProvider<PlayerController, QueueState>(
  PlayerController.new,
);

final positionProvider = StreamProvider<Duration>((ref) {
  final c = ref.watch(playerProvider.notifier);
  // Before loading the saved queue, shows where it had stopped (and the bar dragging).
  ref.watch(playerProvider.select((s) => (s.index, s.queue.length)));
  if (ref.watch(playerProvider.select((s) => s.casting))) {
    return c.remotePositionStream;
  }
  return c.audio.positionStream.map((p) => c.pendingPosition ?? p);
});

final durationProvider = StreamProvider<Duration?>((ref) {
  final c = ref.watch(playerProvider.notifier);
  if (ref.watch(playerProvider.select((s) => s.casting))) {
    final d = ref.watch(playerProvider.select((s) => s.current?.duration));
    return Stream.value(d == Duration.zero ? null : d);
  }
  return c.audio.durationStream;
});

/// Slider volume (what the user chose, without normalization).
final volumeProvider = StreamProvider<double>((ref) {
  final c = ref.watch(playerProvider.notifier);
  return c.volumeStream;
});

final speedProvider = StreamProvider<double>((ref) {
  final c = ref.watch(playerProvider.notifier);
  return c.audio.speedStream;
});
