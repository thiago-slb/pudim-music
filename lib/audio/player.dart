import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../api/catalog.dart';
import '../api/jellyfin.dart';
import '../api/models.dart';
import '../state/downloads.dart';
import '../state/offline.dart';
import '../state/session.dart';
import '../api/response_cache.dart';
import 'media_session.dart';
import '../l10n/l10n.dart';

enum RepeatMode { off, all, one }

/// Jam: no convidado, os botões viram pedidos para o anfitrião (devolve true quando tratou).
typedef JamRemote = bool Function(
  String action, {
  int? index,
  List<Item>? items,
});

/// Estado da fila, no estilo do Spotify:
/// "Tocando agora", "A seguir na fila" (adicionadas à mão) e "Próximas de: `<contexto>`".
class QueueState {
  final List<Item> queue;
  final int index;
  final int manualCount; // quantas depois da atual foram adicionadas à mão
  final String contextName;
  final String? contextRoute; // rota da playlist/álbum/artista que gerou a fila
  final bool shuffle;
  final RepeatMode repeat;
  final bool playing;
  final bool buffering;

  /// Smart Shuffle: aleatório com recomendações no meio (só em playlist).
  final bool smart;

  /// Ids das faixas que o Smart Shuffle colocou (aparecem com ✦ na fila).
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
    this.smart = false,
    this.recommended = const {},
  });

  /// Id da playlist que gerou a fila (null se não for playlist).
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
    smart: smart ?? this.smart,
    recommended: recommended ?? this.recommended,
  );
}

class PlayerController extends Notifier<QueueState> {
  final AudioPlayer audio = AudioPlayer();
  final _subs = <StreamSubscription>[];
  Timer? _progressTimer;
  Item? _reported; // faixa que o Jellyfin sabe que está tocando
  List<Item> _unshuffled = const [];
  bool autoplay = true;
  bool _sourceReady = false; // a faixa atual já foi carregada no player?
  Duration _resumeAt =
      Duration.zero; // posição guardada da última vez que o app fechou
  Timer? _saveTimer;

  /// Jam (convidado): next/previous/play/fila viram pedidos para o anfitrião.
  JamRemote? remote;

  // Last.fm: "tocando agora" e scrobble (metade da música ou 4 min).
  bool _npSent = false, _scrobbled = false;
  DateTime _startedAt = DateTime.now();

  // Gapless: a próxima faixa já fica carregada no player, logo depois da atual.
  String? _preId; // id da faixa carregada depois da atual (null = nenhuma)
  bool _busy = false; // trocando as faixas do player (não confundir com passagem automática)
  Timer? _syncSoon;

  // Volume: o da barra × normalização da faixa × fade do timer para dormir.
  double _userVol = 0.8;
  double _fade = 1;
  final _volume = StreamController<double>.broadcast();

  /// Timer para dormir "fim da música": não emenda a próxima e para quando esta acabar.
  bool _stopAfterCurrent = false;
  void Function()? onSleepEnded;

  Jellyfin get _api => ref.read(apiProvider);

  /// Guarda no painel onde parou no episódio (e na memória, para voltar nele sem esperar o painel).
  void _podcastSave(Item c) {
    final pos = audio.position;
    podcastResume[c.id] = pos;
    final show = c.albumId ?? '';
    unawaited(
      ref
          .read(catalogProvider)
          .podcastProgress(
            c.id.substring(3),
            show.startsWith('podshow') ? show.substring(7) : '',
            pos,
            audio.duration ?? c.duration,
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
    // Mudou o que vem depois da atual (fila, aleatório, repetir): troca a faixa pré-carregada.
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
    MediaSession.instance?.attach(this);
    // Guarda onde parou a cada 5 s tocando (fechar o app perde no máximo isso).
    _saveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (audio.playing) {
        _save();
        _scrobbleTick();
      }
    });
    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _progressTimer?.cancel();
      _saveTimer?.cancel();
      _syncSoon?.cancel();
      _volume.close();
      audio.dispose();
    });
    return _restore(prefs.getString(_saveKey));
  }

  // ---------- lembrar onde parou ----------

  static const _saveKey = 'lastQueue';

  /// Fila, faixa atual, posição, aleatório e repetir: o app abre pausado no mesmo lugar.
  void _save() {
    final st = state;
    final prefs = ref.read(prefsProvider);
    if (st.current == null) {
      prefs.remove(_saveKey);
      return;
    }
    // Guarda até 300 faixas em volta da atual (filas de rádio podem crescer muito).
    final from = max(0, st.index - 50);
    final items = st.queue.skip(from).take(300).toList();
    final pos = _sourceReady ? audio.position : _resumeAt;
    prefs.setString(
      _saveKey,
      jsonEncode({
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
      }),
    );
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
      return const QueueState(); // formato antigo ou estragado: começa vazio
    }
  }

  /// Posição guardada, mostrada antes de a faixa ser carregada (a barra não começa em 0:00).
  Duration? get pendingPosition => _sourceReady ? null : _resumeAt;

  bool get sourceReady => _sourceReady;

  /// Fila atual (para a sessão de mídia, fora do Riverpod).
  QueueState get queue => state;

  /// Cliente do Jellyfin assim que a sessão estiver pronta (Android Auto pode abrir antes da tela).
  Future<Jellyfin?> apiReady() async {
    try {
      return (await ref.read(sessionProvider.future))?.api;
    } catch (_) {
      return null;
    }
  }

  /// Músicas baixadas no aparelho (para o Android Auto).
  List<Item> offlineTracks() =>
      ref.read(offlineProvider).tracks.values.toList();

  void _onPlayerState(PlayerState s) {
    final buffering =
        s.processingState == ProcessingState.loading ||
        s.processingState == ProcessingState.buffering;
    if (s.playing != state.playing || buffering != state.buffering) {
      if (s.playing != state.playing) _save();
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
    if (remote != null) return; // Jam: quem passa para a próxima é o anfitrião
    if (_stopAfterCurrent) {
      // Timer para dormir "fim da música": deixa a próxima pronta, mas parada.
      _stopAfterCurrent = false;
      onSleepEnded?.call();
      if (state.index + 1 < state.queue.length) {
        state = state.copyWith(
          index: state.index + 1,
          manualCount: max(0, state.manualCount - 1),
        );
        await _load(play: false);
      } else {
        await audio.pause();
        await audio.seek(Duration.zero);
      }
      return;
    }
    if (state.repeat == RepeatMode.one) {
      await audio.seek(Duration.zero);
      await audio.play();
      return;
    }
    await next();
  }

  // ---------- tocar ----------

  /// Toca [tracks] começando em [start]. [contextName] aparece na fila como
  /// "Próximas de: ...".
  Future<void> playList(
    List<Item> tracks, {
    int start = 0,
    String contextName = '',
    String? contextRoute,
    bool? shuffle,
  }) async {
    if (tracks.isEmpty) return;
    // Jam (convidado): escolher uma música pede para ela entrar na fila de todos.
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

  /// Smart Shuffle direto da página da playlist.
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

  /// Coloca uma recomendação a cada 3 músicas do que vem depois (Mix instantâneo de algumas da playlist).
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
    if (!state.smart || recs.isEmpty) return; // desligou enquanto buscava
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
      out.add(recs[ri++]); // playlist curta: pelo menos umas recomendações
    }
    state = state.copyWith(
      queue: [...head, ...out],
      recommended: {...state.recommended, for (final r in recs.take(ri)) r.id},
    );
    _save();
  }

  /// Recomendação aceita (foi para a playlist): perde o ✦.
  void acceptRecommendation(String id) {
    state = state.copyWith(recommended: {...state.recommended}..remove(id));
  }

  // ---------- Jam (convidado) ----------

  /// Carrega a fila do anfitrião já na faixa e posição dele.
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

  /// A fila do anfitrião mudou, mas a faixa é a mesma: só troca a lista.
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
    final dur = audio.duration ?? c.duration;
    if (_scrobbled || dur < const Duration(seconds: 30)) return;
    final need = Duration(milliseconds: min(dur.inMilliseconds ~/ 2, 240000));
    if (audio.position >= need) {
      _scrobbled = true;
      unawaited(
        cat.scrobble(c, nowPlaying: false, at: _startedAt).catchError((_) {}),
      );
    }
  }

  /// Toca uma lista começando numa faixa aleatória com o aleatório ligado.
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

  /// De onde tocar [t]: arquivo baixado, podcast, catálogo ou Jellyfin (original ou convertido).
  /// null = sem internet e a faixa não está no aparelho.
  Future<AudioSource?> _sourceFor(Item t) async {
    final dz = t.isCatalog ? t.deezerId : null;
    final direct = t.streamUrl;
    // Baixada no aparelho: toca do arquivo (funciona sem internet).
    final local = dz == null && direct == null
        ? ref.read(offlineProvider.notifier).audioPath(t.id)
        : null;
    if (local != null) return AudioSource.file(local, tag: t);
    if (ResponseCache.instance?.offline.value ?? false) return null;
    if (direct != null) return AudioSource.uri(Uri.parse(direct), tag: t);
    // Faixa do catálogo: o painel acha no YouTube Music e serve o áudio (e já pede o download).
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

  /// Qualidade escolhida para a conexão de agora (0 = arquivo original).
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

  /// Faixa que deve ficar pré-carregada depois da atual (gapless), ou null.
  Item? _desiredNext() {
    final st = state;
    final cur = st.current;
    if (cur == null ||
        cur.isPodcast ||
        remote != null ||
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
    _sourceReady = false;
    _busy = true;
    _preId = null;
    try {
      await _reportStop();
      final src = await _sourceFor(cur);
      if (src == null) {
        // Sem internet: pula direto para a próxima faixa baixada no aparelho.
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
        // Nada baixado depois desta: fica parado nela.
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
        return; // trocou de faixa enquanto preparava
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
      _scheduleSync(); // a fila pode ter mudado enquanto carregava
    } catch (_) {
      // Arquivo com problema: pula para a próxima.
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

  /// Começou a tocar [cur] (carregada agora ou emendada sem pausa): volume, velocidade,
  /// scrobble, "lembrar onde parou" e o reporte para o Jellyfin.
  void _started(Item cur, {required bool play, required Duration at}) {
    _npSent = false;
    _scrobbled = false;
    _startedAt = DateTime.now();
    _applyVolume();
    unawaited(audio.setSpeed(cur.isPodcast ? podcastSpeed : 1.0));
    _save();
    _progressTimer?.cancel();
    if (cur.streamUrl != null) {
      // Podcast: guarda no painel onde parou (continua do mesmo ponto no outro aparelho).
      _progressTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        final c = state.current;
        if (c != null && c.isPodcast && audio.playing) _podcastSave(c);
      });
      return;
    }
    if (cur.isCatalog && cur.deezerId != null) {
      ref.read(downloadsProvider.notifier).refreshSoon();
      return; // o Jellyfin não conhece essa faixa: nada de reportar
    }
    _reported = cur;
    _api.reportStart(cur.id, at, paused: !play);
    _progressTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final c = state.current;
      if (c != null && audio.playing) {
        _api.reportProgress(c.id, audio.position, paused: false);
      }
    });
  }

  /// O player passou sozinho para a faixa pré-carregada (sem pausa entre as duas).
  Future<void> _autoAdvanced() async {
    if (_busy) return;
    final i = audio.currentIndex;
    final seq = audio.sequence;
    if (i == null || i >= seq.length) return;
    final tag = seq[i].tag;
    if (tag is! Item || tag.id != _preId) return;
    await _advanced(tag.id);
  }

  /// A faixa pré-carregada ([id]) virou a atual: acerta a fila e tira a anterior do player.
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

  /// Deixa carregada depois da atual a faixa certa (a fila pode ter mudado).
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
      // sem pré-carregar: a próxima carrega quando esta acabar
    } finally {
      _busy = false;
    }
  }

  // ---------- volume, normalização, velocidade e timer ----------

  /// Volume da barra (sem a normalização), para os controles da tela.
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

  /// Quanto baixar o volume desta faixa para todas ficarem iguais (análise do Jellyfin).
  /// Faixa sem análise usa um valor típico, para não ficar mais alta que as outras.
  double get _gain {
    final c = state.current;
    if (!normalize || c == null || c.isPodcast) return 1;
    return pow(10, (c.normalizationGain ?? -7) / 20).toDouble();
  }

  void _applyVolume() {
    unawaited(audio.setVolume((_userVol * _gain * _fade).clamp(0.0, 1.0)));
  }

  /// Timer para dormir: 1 = normal, 0 = mudo (vai baixando nos últimos segundos).
  set fade(double f) {
    _fade = f.clamp(0.0, 1.0);
    _applyVolume();
  }

  /// Timer "fim da música": a próxima não emenda e o player para quando esta acabar.
  set stopAfterCurrent(bool v) {
    _stopAfterCurrent = v;
    _scheduleSync();
  }

  double get podcastSpeed =>
      ref.read(prefsProvider).getDouble('podSpeed') ?? 1.0;

  /// Velocidade dos podcasts (as músicas tocam sempre em 1×).
  void setPodcastSpeed(double v) {
    ref.read(prefsProvider).setDouble('podSpeed', v);
    if (state.current?.isPodcast ?? false) unawaited(audio.setSpeed(v));
  }

  Future<void> pause() async {
    if (!audio.playing) return;
    if (remote?.call('toggle') ?? false) return;
    await audio.pause();
    final c = state.current;
    if (c != null && c.isPodcast) _podcastSave(c);
  }

  /// Dados da faixa para a notificação, tela de bloqueio e Android Auto.
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
      await _api.reportStopped(r.id, audio.position);
    }
  }

  Future<void> togglePlay() async {
    if (state.current == null) return;
    if (remote?.call('toggle') ?? false) return;
    if (!_sourceReady) {
      // Fila guardada da última vez: carrega agora e continua de onde parou.
      await _load(play: true, at: _resumeAt);
      return;
    }
    if (audio.playing) {
      await audio.pause();
      final c = state.current;
      if (c != null && c.isPodcast) _podcastSave(c);
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
      // Já está carregada: só passa para ela.
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
    await audio.pause();
    await audio.seek(Duration.zero);
  }

  /// Quando a fila acaba, continua com o Mix instantâneo da última faixa.
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
    if (audio.position > const Duration(seconds: 3) || state.index <= 0) {
      await audio.seek(Duration.zero);
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
      // Fila guardada ainda não carregada: carrega pausada já na posição escolhida.
      if (state.current != null) await _load(play: false, at: d);
      return;
    }
    await audio.seek(d);
  }

  Future<void> setVolume(double v) async {
    _userVol = v;
    _volume.add(v);
    _applyVolume();
    ref.read(prefsProvider).setDouble('volume', v);
  }

  // ---------- fila ----------

  /// "Adicionar à fila": entra depois das que já foram adicionadas à mão.
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

  /// "Tocar em seguida": logo depois da atual.
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

  /// Reordena dentro do que vem depois da atual ([from]/[to] são índices da fila).
  void move(int from, int to) {
    if (from <= state.index || to <= state.index) return;
    final q = List<Item>.of(state.queue);
    final t = q.removeAt(from);
    q.insert(to > from ? to - 1 : to, t);
    state = state.copyWith(queue: q);
  }

  /// Aleatório → Smart Shuffle (em playlist) → desligado.
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
      // Desliga tudo: as recomendações que ainda não tocaram saem da fila.
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
      // Volta para a ordem original a partir da faixa atual.
      final pos = _unshuffled.indexWhere((t) => t.id == cur.id);
      final headIds = head.map((t) => t.id).toSet();
      final rest = (pos >= 0 ? _unshuffled.skip(pos + 1) : _unshuffled)
          .where((t) => !headIds.contains(t.id))
          .toList();
      state = state.copyWith(queue: [...head, ...rest], shuffle: false);
    }
  }

  void cycleRepeat() {
    final next = RepeatMode.values[(state.repeat.index + 1) % 3];
    state = state.copyWith(repeat: next);
  }

  void setAutoplay(bool v) {
    autoplay = v;
    ref.read(prefsProvider).setBool('autoplay', v);
  }

  /// Atualiza o favorito da faixa em todos os lugares da fila.
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

/// Onde parou em cada episódio de podcast (id "pod…"), vindo do painel ao abrir a página do podcast.
final podcastResume = <String, Duration>{};

final playerProvider = NotifierProvider<PlayerController, QueueState>(
  PlayerController.new,
);

final positionProvider = StreamProvider<Duration>((ref) {
  final c = ref.watch(playerProvider.notifier);
  // Antes de carregar a fila guardada, mostra onde tinha parado (e o arrastar da barra).
  ref.watch(playerProvider.select((s) => (s.index, s.queue.length)));
  return c.audio.positionStream.map((p) => c.pendingPosition ?? p);
});

final durationProvider = StreamProvider<Duration?>((ref) {
  final c = ref.watch(playerProvider.notifier);
  return c.audio.durationStream;
});

/// Volume da barra (o que a pessoa escolheu, sem a normalização).
final volumeProvider = StreamProvider<double>((ref) {
  final c = ref.watch(playerProvider.notifier);
  return c.volumeStream;
});

final speedProvider = StreamProvider<double>((ref) {
  final c = ref.watch(playerProvider.notifier);
  return c.audio.speedStream;
});
