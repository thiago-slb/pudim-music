import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../api/jellyfin.dart';
import '../api/models.dart';
import 'player.dart';

/// Sessão de mídia do celular: notificação, tela de bloqueio, fones Bluetooth, widget
/// e Android Auto (navegar pela biblioteca no carro).
///
/// O player de verdade é o [PlayerController]; esta classe só espelha o estado dele para o
/// sistema e repassa os botões. No Android Auto, as pastas vêm do Jellyfin.
class MediaSession extends BaseAudioHandler with SeekHandler {
  MediaSession._();

  static MediaSession? instance;

  static Future<void> init() async {
    instance = await AudioService.init(
      builder: MediaSession._,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'io.github.thiagoslb.pudim.audio',
        androidNotificationChannelName: 'Reprodução',
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        fastForwardInterval: Duration(seconds: 15),
        rewindInterval: Duration(seconds: 15),
      ),
    );
  }

  PlayerController? _c;
  final _subs = <StreamSubscription>[];

  /// Músicas de cada pasta já aberta no carro (para tocar a pasta inteira a partir da escolhida).
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
      ..add(a.playbackEventStream.listen((_) => _broadcast(), onError: (_, _) {}))
      ..add(a.playingStream.listen((_) => _broadcast()))
      ..add(a.speedStream.listen((_) => _broadcast()))
      ..add(a.durationStream.listen((_) => _pushItem()));
    _pushItem();
    _broadcast();
  }

  /// Chamado a cada mudança da fila.
  void update(QueueState? prev, QueueState next) {
    final a = prev?.current, b = next.current;
    if (a?.id != b?.id || a?.favorite != b?.favorite) _pushItem();
    if (prev?.playing != next.playing ||
        prev?.buffering != next.buffering ||
        prev?.index != next.index) {
      _broadcast();
    }
  }

  void _pushItem() {
    final c = _c;
    final t = c?.queue.current;
    if (c == null || t == null) {
      if (mediaItem.value != null) mediaItem.add(null);
      return;
    }
    try {
      mediaItem.add(c.mediaItemOf(t, duration: c.audio.duration));
    } catch (_) {
      // sem sessão ainda: a capa e o resto chegam na próxima mudança
    }
  }

  void _broadcast() {
    final c = _c;
    if (c == null) return;
    final a = c.audio;
    final st = c.queue;
    final playing = a.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: st.current == null || !c.sourceReady
            ? AudioProcessingState.idle
            : switch (a.processingState) {
                ProcessingState.loading => AudioProcessingState.loading,
                ProcessingState.buffering => AudioProcessingState.buffering,
                _ => AudioProcessingState.ready,
              },
        playing: playing,
        updatePosition: a.position,
        bufferedPosition: a.bufferedPosition,
        speed: a.speed,
        queueIndex: st.index < 0 ? null : st.index,
      ),
    );
  }

  // ---------- botões ----------

  @override
  Future<void> play() async {
    final c = _c;
    if (c != null && !c.audio.playing) await c.togglePlay();
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
  Future<void> skipToQueueItem(int index) async => _c?.jumpTo(index);

  // ---------- Android Auto: pastas ----------

  static const _hintGrid = {
    'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2,
    'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1,
  };

  MediaItem _folder(String id, String title, {String? art, bool grid = false}) =>
      MediaItem(
        id: id,
        title: title,
        playable: false,
        artUri: art == null ? null : Uri.parse(art),
        extras: grid ? _hintGrid : null,
      );

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
    final api = await c.apiReady();
    if (api == null) return const [];
    try {
      if (parentMediaId == AudioService.browsableRootId) {
        return [
          _folder('recent', 'Tocadas recentemente'),
          _folder('liked', 'Músicas curtidas'),
          _folder('pl', 'Playlists', grid: true),
          _folder('albums', 'Álbuns recentes', grid: true),
          _folder('artists', 'Artistas', grid: true),
          if (c.offlineTracks().isNotEmpty) _folder('offline', 'Baixadas'),
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
    artUri: switch (api.imageUrl(a.imageItemId)) {
      final u? => Uri.parse(u),
      null => null,
    },
  );

  MediaItem _track(String ctx, Item t, PlayerController c) {
    final m = c.mediaItemOf(t);
    return m.copyWith(id: '$ctx|${t.id}', playable: true);
  }

  Future<List<Item>> _tracksOf(
    String ctx,
    Jellyfin api,
    PlayerController c,
  ) async {
    final List<Item> list;
    if (ctx == 'recent') {
      list = await api.recentlyPlayedTracks(limit: 50);
    } else if (ctx == 'liked') {
      list = await api.favoriteTracks();
    } else if (ctx == 'offline') {
      list = c.offlineTracks();
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

  static const _ctxNames = {
    'recent': 'Tocadas recentemente',
    'liked': 'Músicas curtidas',
    'offline': 'Baixadas',
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
    final api = await c.apiReady();
    if (api == null) return;
    final tracks = _lists[ctx] ?? await _tracksOf(ctx, api, c);
    final i = tracks.indexWhere((t) => t.id == id);
    if (i < 0) return;
    await c.playList(
      tracks,
      start: i,
      contextName: _titles[ctx] ?? _ctxNames[ctx] ?? '',
      contextRoute: ctx.startsWith('pl:')
          ? '/playlist/${ctx.substring(3)}'
          : ctx.startsWith('al:')
          ? '/album/${ctx.substring(3)}'
          : null,
    );
  }

  /// "Ok Google, tocar … no Pudim".
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
      return c.shufflePlay(liked, contextName: 'Músicas curtidas');
    }
    final found = await api.search(query, 'Audio', limit: 30);
    if (found.isEmpty) return;
    await c.playList(found, contextName: 'Busca: $query');
  }
}
