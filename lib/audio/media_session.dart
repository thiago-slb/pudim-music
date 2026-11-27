import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/jellyfin.dart';
import '../api/models.dart';
import 'player.dart';
import '../l10n/l10n.dart';

/// Phone media session: notification, lock screen, Bluetooth headphones, widget
/// and Android Auto (browsing the library in the car).
///
/// The real player is [PlayerController]; this class only mirrors its state to the
/// system and forwards the buttons. In Android Auto, the folders come from Jellyfin.
class MediaSession extends BaseAudioHandler with SeekHandler {
  MediaSession._();

  static MediaSession? instance;

  static Future<void> init() async {
    instance = await AudioService.init(
      builder: MediaSession._,
      config: AudioServiceConfig(
        androidNotificationChannelId: 'io.github.thiagoslb.pudim.audio',
        androidNotificationChannelName: appL10n.audioPlaybackChannel,
        androidNotificationIcon: 'drawable/ic_stat_pudim',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        fastForwardInterval: Duration(seconds: 15),
        rewindInterval: Duration(seconds: 15),
        // The car offers search; folders show as lists unless they ask for a grid.
        androidBrowsableRootExtras: {
          'android.media.browse.SEARCH_SUPPORTED': true,
          'android.media.browse.CONTENT_STYLE_SUPPORTED': true,
          'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 1,
          'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1,
        },
      ),
    );
  }

  PlayerController? _c;
  final _subs = <StreamSubscription>[];

  /// Tracks of each folder already opened in the car (to play the whole folder from the chosen one).
  final _lists = <String, List<Item>>{};
  final _titles = <String, String>{};

  void attach(PlayerController c) {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
    _c = c;
    final a = c.audio;
    _subs
      ..add(
        a.playbackEventStream.listen((_) => _broadcast(), onError: (_, _) {}),
      )
      ..add(a.playingStream.listen((_) => _broadcast()))
      ..add(a.speedStream.listen((_) => _broadcast()))
      ..add(a.durationStream.listen((_) => _pushItem()))
      // Gapless advance changes the playing source before the queue catches up.
      ..add(a.currentIndexStream.listen((_) => _pushItem()));
    _pushItem();
    _pushQueue(c.queue);
    _broadcast();
  }

  /// Called on every queue change.
  void update(QueueState? prev, QueueState next) {
    final a = prev?.current, b = next.current;
    // Also when the system has no track or a stale one (an earlier send failed): otherwise the car
    // plays with an empty mini player until the track changes.
    if (a?.id != b?.id ||
        a?.favorite != b?.favorite ||
        (_c != null && mediaItem.value?.id != _nowPlaying(_c!)?.id)) {
      _pushItem();
    }
    if (!identical(prev?.queue, next.queue) ||
        prev?.index != next.index ||
        prev?.contextName != next.contextName) {
      _pushQueue(next);
    }
    if (prev?.playing != next.playing ||
        prev?.buffering != next.buffering ||
        prev?.castingTo != next.castingTo ||
        prev?.index != next.index ||
        prev?.shuffle != next.shuffle ||
        prev?.repeat != next.repeat ||
        a?.favorite != b?.favorite) {
      _broadcast();
    }
  }

  /// Sends the track and the queue again (for example once the login loads, for the covers).
  void refresh() {
    final c = _c;
    if (c == null) return;
    _pushItem();
    _pushQueue(c.queue);
  }

  void _pushItem() {
    final c = _c;
    final t = c == null ? null : _nowPlaying(c);
    if (c == null || t == null) {
      if (mediaItem.value != null) mediaItem.add(null);
      return;
    }
    try {
      mediaItem.add(c.mediaItemOf(t, duration: c.duration));
    } catch (_) {
      // no session yet: the cover and the rest arrive on the next change
    }
  }

  /// Position of the first queue track sent to the car: only a window around the current one
  /// goes, since a long queue does not fit in one message to the system.
  int _queueOffset = 0;

  /// The queue the car shows under "Up next" (tap one to jump to it).
  void _pushQueue(QueueState st) {
    final c = _c;
    if (c == null) return;
    try {
      final w = queueWindow(st.index, st.queue.length);
      _queueOffset = w.from;
      queue.add([
        for (var i = w.from; i < w.to; i++)
          c.mediaItemOf(st.queue[i]).copyWith(id: 'q|$i|${st.queue[i].id}'),
      ]);
      queueTitle.add(st.contextName);
    } catch (_) {
      // no session yet: goes with the next change
    }
  }

  /// Part of the queue sent to the car: 10 before the current track and up to 100 in all.
  static ({int from, int to}) queueWindow(int index, int length) {
    final from = (index - 10).clamp(0, length);
    return (from: from, to: (from + 100).clamp(0, length));
  }

  /// The track the car and the notification should show: the queue's current one, unless the player
  /// already moved on by itself to the next one and the queue has not caught up yet.
  Item? _nowPlaying(PlayerController c) {
    final st = c.queue;
    final cur = st.current;
    if (st.casting) return cur;
    final i = c.audio.currentIndex;
    final seq = c.audio.sequence;
    if (i == null || i >= seq.length) return cur;
    final tag = seq[i].tag;
    if (tag is Item && tag.id != cur?.id && tag.id == st.next?.id) return tag;
    return cur;
  }

  void _broadcast() {
    final c = _c;
    if (c == null) return;
    final a = c.audio;
    final st = c.queue;
    final playing = c.isPlaying;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          ...extraControls(st),
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
          MediaAction.skipToQueueItem,
          MediaAction.setShuffleMode,
          MediaAction.setRepeatMode,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: st.current == null || !c.sourceReady
            ? AudioProcessingState.idle
            : st.casting
            ? (st.buffering
                  ? AudioProcessingState.buffering
                  : AudioProcessingState.ready)
            : switch (a.processingState) {
                ProcessingState.loading => AudioProcessingState.loading,
                ProcessingState.buffering => AudioProcessingState.buffering,
                _ => AudioProcessingState.ready,
              },
        playing: playing,
        updatePosition: c.position,
        bufferedPosition: st.casting ? c.position : a.bufferedPosition,
        speed: st.casting ? 1.0 : a.speed,
        queueIndex: st.index < 0 ? null : st.index - _queueOffset,
        shuffleMode: st.shuffle
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        repeatMode: switch (st.repeat) {
          RepeatMode.off => AudioServiceRepeatMode.none,
          RepeatMode.all => AudioServiceRepeatMode.all,
          RepeatMode.one => AudioServiceRepeatMode.one,
        },
      ),
    );
  }

  /// Like, shuffle and repeat: extra buttons in the car (and the expanded notification). The
  /// icon shows the current state; the label says what a tap does.
  static List<MediaControl> extraControls(QueueState st) {
    final cur = st.current;
    final l = appL10n;
    return [
      if (cur != null && !cur.isCatalog)
        MediaControl.custom(
          androidIcon: cur.favorite
              ? 'drawable/ic_car_liked'
              : 'drawable/ic_car_like',
          label: cur.favorite ? l.commonRemoveFromLiked : l.commonAddToLiked,
          name: 'like',
        ),
      MediaControl.custom(
        androidIcon: st.shuffle
            ? 'drawable/ic_car_shuffle_on'
            : 'drawable/ic_car_shuffle',
        label: st.shuffle ? l.playerBarShuffleOff : l.playerBarShuffleOn,
        name: 'shuffle',
      ),
      MediaControl.custom(
        androidIcon: switch (st.repeat) {
          RepeatMode.off => 'drawable/ic_car_repeat',
          RepeatMode.all => 'drawable/ic_car_repeat_on',
          RepeatMode.one => 'drawable/ic_car_repeat_one',
        },
        label: switch (st.repeat) {
          RepeatMode.off => l.playerBarRepeatOn,
          RepeatMode.all => l.playerBarRepeatOne,
          RepeatMode.one => l.playerBarRepeatOff,
        },
        name: 'repeat',
      ),
    ];
  }

  // ---------- buttons ----------

  @override
  Future<void> play() async {
    final c = _c;
    if (c != null && !c.isPlaying) await c.togglePlay();
  }

  @override
  Future<void> pause() async => _c?.pause();

  @override
  Future<void> stop() async => _c?.pause();

  @override
  Future<void> skipToNext() async => _c?.next();

  @override
  Future<void> skipToPrevious() async => _c?.previous();

  @override
  Future<void> seek(Duration position) async => _c?.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async =>
      _c?.jumpTo(index + _queueOffset);

  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    final c = _c;
    if (c == null) return;
    switch (name) {
      case 'like':
        await c.toggleCurrentFavorite();
      case 'shuffle':
        c.toggleShuffle(smartStep: false);
      case 'repeat':
        c.cycleRepeat();
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final c = _c;
    if (c == null) return;
    final on = shuffleMode != AudioServiceShuffleMode.none;
    if (c.queue.shuffle != on) c.toggleShuffle(smartStep: false);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    final c = _c;
    if (c == null) return;
    final want = switch (repeatMode) {
      AudioServiceRepeatMode.none => RepeatMode.off,
      AudioServiceRepeatMode.one => RepeatMode.one,
      _ => RepeatMode.all,
    };
    for (var i = 0; i < 3 && c.queue.repeat != want; i++) {
      c.cycleRepeat();
    }
  }

  // ---------- Android Auto: folders ----------

  static const _hintGrid = {
    'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2,
    'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1,
  };

  MediaItem _folder(
    String id,
    String title, {
    String? art,
    bool grid = false,
  }) => MediaItem(
    id: id,
    title: title,
    playable: false,
    artUri: _carArt(art),
    extras: grid ? _hintGrid : null,
  );

  /// Server the car covers come from (see [carArtUri]).
  String? _base;
  static String? _appId;

  /// The car only loads content:// covers: server covers go through CarArtProvider.
  Uri? _carArt(String? url) {
    if (url == null) return null;
    if (!Platform.isAndroid) return Uri.parse(url);
    try {
      _appId ??= File('/proc/self/cmdline')
          .readAsStringSync()
          .split('\u0000')
          .first
          .split(':')
          .first
          .trim();
    } catch (_) {
      return Uri.parse(url);
    }
    return carArtUri(url, base: _base, appId: _appId!);
  }

  /// `content://APP_ID.carart/img?u=URL` for covers on [base], `?f=PATH` for covers saved with
  /// downloads (the car cannot open the app's files); others stay as they are.
  static Uri carArtUri(String url, {String? base, required String appId}) {
    final file = url.startsWith('file://');
    if (appId.isEmpty ||
        (!file && (base == null || !url.startsWith('$base/')))) {
      return Uri.parse(url);
    }
    return Uri(
      scheme: 'content',
      host: '$appId.carart',
      path: '/img',
      queryParameters: file
          ? {'f': Uri.parse(url).toFilePath(windows: false)}
          : {'u': url},
    );
  }

  /// Tells CarArtProvider which server it may fetch covers from.
  Future<void> _allowCovers(Jellyfin api) async {
    if (_base == api.baseUrl) return;
    _base = api.baseUrl;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('carArtBase', api.baseUrl);
    } catch (_) {}
  }

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    final c = _c;
    if (c == null) return const [];
    if (parentMediaId == AudioService.recentRootId) {
      final t = c.queue.current;
      return t == null ? const [] : [_track('now', t, c)];
    }
    // Downloaded songs work without the server (no signal on the road).
    if (parentMediaId == 'offline') {
      final list = await _tracksOf('offline', null, c);
      return [for (final t in list) _track('offline', t, c)];
    }
    final api = await c.apiReady();
    if (api == null) {
      return parentMediaId == AudioService.browsableRootId &&
              c.offlineTracks().isNotEmpty
          ? [_folder('offline', appL10n.commonDownloaded)]
          : const [];
    }
    await _allowCovers(api);
    try {
      if (parentMediaId == AudioService.browsableRootId) {
        return [
          _folder('recent', appL10n.commonRecentlyPlayed),
          _folder('liked', appL10n.commonLikedSongs),
          _folder('pl', appL10n.commonPlaylists, grid: true),
          _folder('albums', appL10n.audioRecentAlbums, grid: true),
          _folder('artists', appL10n.commonArtists, grid: true),
          if (c.offlineTracks().isNotEmpty)
            _folder('offline', appL10n.commonDownloaded),
        ];
      }
      switch (parentMediaId) {
        case 'pl':
          return [
            for (final p in await api.playlists())
              _folder(
                _named('pl:${p.id}', p.name),
                p.name,
                art: api.imageUrl(p.imageItemId),
              ),
          ];
        case 'albums':
          return [
            for (final a in await api.latestAlbums(limit: 60)) _album(a, api),
          ];
        case 'artists':
          return [
            for (final a in await api.favoriteArtists())
              _folder(
                _named('ar:${a.id}', a.name),
                a.name,
                art: api.imageUrl(a.imageItemId),
                grid: true,
              ),
          ];
      }
      if (parentMediaId.startsWith('ar:')) {
        return [
          for (final a in await api.artistAlbums(parentMediaId.substring(3)))
            _album(a, api),
        ];
      }
      final tracks = await _tracksOf(parentMediaId, api, c);
      return [for (final t in tracks) _track(parentMediaId, t, c)];
    } catch (_) {
      return const [];
    }
  }

  String _named(String id, String title) {
    _titles[id] = title;
    return id;
  }

  MediaItem _album(Item a, Jellyfin api) => MediaItem(
    id: _named('al:${a.id}', a.name),
    title: a.name,
    artist: a.artistLine,
    playable: false,
    artUri: _carArt(api.imageUrl(a.imageItemId)),
  );

  MediaItem _track(String ctx, Item t, PlayerController c) {
    final m = c.mediaItemOf(t);
    return m.copyWith(
      id: '$ctx|${t.id}',
      playable: true,
      artUri: _carArt(m.artUri?.toString()),
    );
  }

  Future<List<Item>> _tracksOf(
    String ctx,
    Jellyfin? api,
    PlayerController c,
  ) async {
    final List<Item> list;
    if (ctx == 'offline') {
      list = c.offlineTracks();
    } else if (api == null) {
      list = const [];
    } else if (ctx.startsWith('search:')) {
      list = await api.search(ctx.substring(7), 'Audio', limit: 30);
    } else if (ctx == 'recent') {
      list = await api.recentlyPlayedTracks(limit: 50);
    } else if (ctx == 'liked') {
      list = await api.favoriteTracks();
    } else if (ctx.startsWith('pl:')) {
      list = await api.playlistTracks(ctx.substring(3));
    } else if (ctx.startsWith('al:')) {
      list = await api.albumTracks(ctx.substring(3));
    } else {
      list = const [];
    }
    _lists[ctx] = list;
    return list;
  }

  static Map<String, String> get _ctxNames => {
    'recent': appL10n.commonRecentlyPlayed,
    'liked': appL10n.commonLikedSongs,
    'offline': appL10n.commonDownloaded,
  };

  @override
  Future<void> playFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) async {
    final c = _c;
    if (c == null) return;
    final cut = mediaId.lastIndexOf('|');
    if (cut < 0) return;
    final ctx = mediaId.substring(0, cut);
    final id = mediaId.substring(cut + 1);
    if (ctx == 'now') return play();
    final tracks =
        _lists[ctx] ??
        await _tracksOf(ctx, ctx == 'offline' ? null : await c.apiReady(), c);
    final i = tracks.indexWhere((t) => t.id == id);
    if (i < 0) return;
    await c.playList(
      tracks,
      start: i,
      contextName:
          _titles[ctx] ??
          _ctxNames[ctx] ??
          (ctx.startsWith('search:')
              ? appL10n.audioSearchContext(ctx.substring(7))
              : ''),
      contextRoute: ctx.startsWith('pl:')
          ? '/playlist/${ctx.substring(3)}'
          : ctx.startsWith('al:')
          ? '/album/${ctx.substring(3)}'
          : null,
    );
  }

  /// Search typed or spoken in the car: songs; tapping one plays the results from it.
  @override
  Future<List<MediaItem>> search(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    final c = _c;
    final q = query.trim();
    if (c == null || q.isEmpty) return const [];
    final api = await c.apiReady();
    if (api == null) return const [];
    await _allowCovers(api);
    try {
      final ctx = 'search:$q';
      return [for (final t in await _tracksOf(ctx, api, c)) _track(ctx, t, c)];
    } catch (_) {
      return const [];
    }
  }

  /// "Ok Google, play … on Pudim".
  @override
  Future<void> playFromSearch(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    final c = _c;
    if (c == null) return;
    final api = await c.apiReady();
    if (api == null) return;
    if (query.trim().isEmpty) {
      if (c.queue.current != null) return play();
      final liked = await api.favoriteTracks();
      return c.shufflePlay(liked, contextName: appL10n.commonLikedSongs);
    }
    final found = await api.search(query, 'Audio', limit: 30);
    if (found.isEmpty) return;
    await c.playList(found, contextName: appL10n.audioSearchContext(query));
  }
}
