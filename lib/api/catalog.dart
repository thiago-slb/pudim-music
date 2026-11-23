import 'package:dio/dio.dart';

import 'models.dart';
import '../l10n/l10n.dart';

class CatalogSearch {
  final List<Item> tracks, albums, artists, playlists;
  const CatalogSearch(this.tracks, this.albums, this.artists, this.playlists);
  static const empty = CatalogSearch([], [], [], []);
}

class CatalogArtist {
  final Item? artist;
  final List<Item> top, albums, related;
  const CatalogArtist(this.artist, this.top, this.albums, this.related);
}

class CatalogList {
  final Item head;
  final List<Item> tracks;
  const CatalogList(this.head, this.tracks);
}

/// Download pedido pelo app (um job no servidor de extras).
class DownloadJob {
  final String id;
  final String status;
  final String? step;
  final String kind; // track | album | artist
  final String title;
  final String artist;
  final String? cover;
  final String? summary;
  final DateTime created;
  final DateTime? end;

  const DownloadJob({
    required this.id,
    required this.status,
    this.step,
    required this.kind,
    required this.title,
    required this.artist,
    this.cover,
    this.summary,
    required this.created,
    this.end,
  });

  bool get active => const {'na_fila', 'rodando', 'baixando'}.contains(status);
  bool get ok => const {'concluido', 'em_dia'}.contains(status);
  bool get failed => !active && !ok && status != 'parcial';

  String get statusLabel => switch (status) {
    'na_fila' => appL10n.apiStatusQueued,
    'rodando' || 'baixando' => step ?? appL10n.apiStatusDownloading,
    'concluido' => appL10n.apiStatusDone,
    'em_dia' => appL10n.apiStatusUpToDate,
    'parcial' => appL10n.apiStatusPartial,
    'nao_encontrado' => appL10n.apiStatusNotFound,
    'cancelado' => appL10n.apiStatusCancelled,
    'interrompido' => appL10n.apiStatusInterrupted,
    _ => appL10n.apiStatusFailed,
  };

  static DateTime _t(num? s) =>
      DateTime.fromMillisecondsSinceEpoch(((s ?? 0) * 1000).round());

  factory DownloadJob.fromJson(Map<String, dynamic> j) => DownloadJob(
    id: j['id'] as String,
    status: j['status'] as String? ?? '',
    step: j['step'] as String?,
    kind: j['kind'] as String? ?? 'track',
    title: j['title'] as String? ?? '',
    artist: j['artist'] as String? ?? '',
    cover: j['cover'] as String?,
    summary: j['summary'] as String?,
    created: _t(j['created'] as num?),
    end: j['end'] == null ? null : _t(j['end'] as num?),
  );
}

/// Álbum da pasta da biblioteca com a qualidade (do painel).
/// Álbum que falta na biblioteca (da discografia no MusicBrainz).
class PlanAlbum {
  final String rgid, title, year, type;
  final List<String> secondary;
  final bool partial;
  const PlanAlbum(
    this.rgid,
    this.title,
    this.year,
    this.type,
    this.secondary,
    this.partial,
  );

  /// Álbum de estúdio: tipo Album sem ao vivo, coletânea, trilha...
  bool get studio => type == 'Album' && secondary.isEmpty;

  factory PlanAlbum.fromJson(Map<String, dynamic> j) => PlanAlbum(
    '${j['rgid']}',
    '${j['title'] ?? ''}',
    '${j['year'] ?? ''}',
    '${j['type'] ?? ''}',
    [for (final s in (j['secondary'] as List? ?? const [])) '$s'],
    j['partial'] == true,
  );
}

class AlbumPlan {
  final String artist, query;
  final int have, skippedOneSong;
  final List<PlanAlbum> missing;
  const AlbumPlan(
    this.artist,
    this.query,
    this.have,
    this.skippedOneSong,
    this.missing,
  );

  factory AlbumPlan.fromJson(Map<String, dynamic> j) => AlbumPlan(
    '${j['artist'] ?? ''}',
    '${j['query'] ?? j['artist'] ?? ''}',
    (j['have'] as num?)?.toInt() ?? 0,
    (j['skipped_one_song'] as num?)?.toInt() ?? 0,
    [
      for (final a in (j['missing'] as List? ?? const []))
        if (a is Map<String, dynamic>) PlanAlbum.fromJson(a),
    ],
  );
}

class AlbumQuality {
  final String folder, title, year;
  final bool flac, poor, partial;
  final int? kbps;
  const AlbumQuality({
    required this.folder,
    required this.title,
    required this.year,
    this.flac = false,
    this.poor = false,
    this.partial = false,
    this.kbps,
  });
  factory AlbumQuality.fromJson(Map<String, dynamic> j) => AlbumQuality(
    folder: j['folder'] as String? ?? '',
    title: j['title'] as String? ?? '',
    year: j['year'] as String? ?? '',
    flac: j['flac'] == true,
    poor: j['poor'] == true,
    partial: j['partial'] == true,
    kbps: (j['kbps'] as num?)?.toInt(),
  );
}

class ArtistQuality {
  final String name;
  final List<AlbumQuality> albums;
  final int poor;
  const ArtistQuality(this.name, this.albums, this.poor);
  static const empty = ArtistQuality('', [], 0);

  static String _key(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'\s*[\(\[].*?[\)\]]'), '')
      .replaceAll(RegExp(r'[^a-z0-9à-ÿ]+'), '');

  /// Acha o álbum da pasta pelo nome do álbum no Jellyfin (sem "(Deluxe)", maiúsculas etc.).
  AlbumQuality? of(String albumName) {
    final want = _key(albumName);
    for (final a in albums) {
      if (_key(a.title) == want) return a;
    }
    return null;
  }
}

/// Detalhes de um download (para "Ver detalhes" no sino).
class JobDetail {
  final String status;
  final String? summary;
  final List<String> albums;
  final List<String> log;
  const JobDetail(this.status, this.summary, this.albums, this.log);
}

/// Descobertas ou Mistura da semana da conta.
class MixInfo {
  final String name;
  final bool thisWeek, running, available;
  final int tracks;
  final DateTime? generated;
  final String? error;
  const MixInfo({
    required this.name,
    this.thisWeek = false,
    this.running = false,
    this.available = true,
    this.tracks = 0,
    this.generated,
    this.error,
  });

  factory MixInfo.fromJson(Map<String, dynamic> j, {required bool mistura}) =>
      MixInfo(
        name: j['name'] as String? ?? '',
        thisWeek: mistura
            ? j['week'] != null && j['week'] == isoWeek(DateTime.now())
            : j['this_week'] == true,
        running: j['running'] == true,
        available: mistura ? j['available'] == true : true,
        tracks: (j['tracks'] as num?)?.toInt() ?? 0,
        generated: j['generated'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                ((j['generated'] as num) * 1000).round(),
              ),
        error: j['error'] as String?,
      );

  /// Semana ISO no formato do painel ("2026-W47").
  static String isoWeek(DateTime d) {
    final thursday = DateTime(d.year, d.month, d.day + 4 - d.weekday);
    final first = DateTime(thursday.year, 1, 1);
    final week = (thursday.difference(first).inDays ~/ 7) + 1;
    return '${thursday.year}-W${week.toString().padLeft(2, '0')}';
  }
}

class Notice {
  final double ts;
  final String title, body, tag;
  const Notice(this.ts, this.title, this.body, this.tag);
}

class CatalogException implements Exception {
  final String message;
  CatalogException(this.message);
  @override
  String toString() => message;
}

/// Cliente das rotas `/api/player/*` do servidor de extras (opcional): catálogo, downloads, social e mixes.
/// Usa o mesmo token do Jellyfin; o servidor confere quem é a conta. Sem endereço, tudo falha na hora
/// com [CatalogException] (as telas que dependem dele ficam escondidas, ver `hasExtrasProvider`).
class Catalog {
  final String token;
  late final Dio _dio;

  Catalog(this.token, {String baseUrl = '', HttpClientAdapter? adapter}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 40),
        headers: {'Authorization': authHeader},
      ),
    );
    if (adapter != null) _dio.httpClientAdapter = adapter;
    if (baseUrl.isEmpty) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) => h.reject(
            DioException(requestOptions: o, message: 'Sem servidor de extras.'),
          ),
        ),
      );
    }
  }

  /// Tem servidor de extras configurado?
  bool get enabled => _dio.options.baseUrl.isNotEmpty;

  String get authHeader => 'MediaBrowser Token="$token"';
  Map<String, String> get headers => {'Authorization': authHeader};

  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, dynamic>? q,
  ]) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(path, queryParameters: q);
      return r.data ?? const {};
    } on DioException catch (e) {
      final err = (e.response?.data is Map)
          ? (e.response!.data as Map)['error']
          : null;
      throw CatalogException(err?.toString() ?? appL10n.apiExtrasNoResponse);
    }
  }

  static List<Item> _items(Object? list) => ((list as List?) ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(Item.fromCatalog)
      .toList();

  Future<CatalogSearch> search(String q) async {
    final d = await _get('/api/player/search', {'q': q});
    return CatalogSearch(
      _items(d['tracks']),
      _items(d['albums']),
      _items(d['artists']),
      _items(d['playlists']),
    );
  }

  /// Por id do Deezer ou pelo nome (artista da biblioteca, para os Populares).
  Future<CatalogArtist> artist({int? id, String? name}) async {
    final d = await _get('/api/player/artist', {
      'id': ?id?.toString(),
      'name': ?name,
    });
    final a = d['artist'];
    return CatalogArtist(
      a is Map<String, dynamic> ? Item.fromCatalog(a) : null,
      _items(d['top']),
      _items(d['albums']),
      _items(d['related']),
    );
  }

  Future<CatalogList> album(int id) async {
    final d = await _get('/api/player/album', {'id': '$id'});
    return CatalogList(
      Item.fromCatalog(d['album'] as Map<String, dynamic>),
      _items(d['tracks']),
    );
  }

  Future<CatalogList> playlist(int id) async {
    final d = await _get('/api/player/playlist', {'id': '$id'});
    return CatalogList(
      Item.fromCatalog(d['playlist'] as Map<String, dynamic>),
      _items(d['tracks']),
    );
  }

  /// Endereço para o player: o painel acha no YouTube Music, baixa e redireciona para o áudio.
  /// Também cria o download da música ("toca já e baixa junto").
  String playUrl(int deezerId) =>
      '${_dio.options.baseUrl}/api/player/play/$deezerId';

  /// kind: track | album | artist. Devolve true se já estava na fila.
  Future<bool> download(String kind, int deezerId) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/api/player/download',
        data: {'kind': kind, 'deezer_id': deezerId},
      );
      return r.data?['already'] == true;
    } on DioException catch (e) {
      final err = (e.response?.data is Map)
          ? (e.response!.data as Map)['error']
          : null;
      throw CatalogException(err?.toString() ?? appL10n.apiExtrasNoResponse);
    }
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, [
    Object? data,
  ]) async {
    try {
      final r = await _dio.request<Map<String, dynamic>>(
        path,
        data: data,
        options: Options(method: method),
      );
      return r.data ?? const {};
    } on DioException catch (e) {
      final err = (e.response?.data is Map)
          ? (e.response!.data as Map)['error']
          : null;
      throw CatalogException(err?.toString() ?? appL10n.apiExtrasNoResponse);
    }
  }

  // ---------- histórico do Spotify na Retrospectiva ----------

  /// Quantas reproduções do Spotify já entraram e de quando a quando.
  Future<Map<String, dynamic>> spotifyHistory() =>
      _get('/api/player/recap/spotify');

  /// Manda o zip (my_spotify_data.zip) ou um Streaming_History_Audio_*.json.
  Future<Map<String, dynamic>> importSpotify(
    List<int> bytes,
    String filename,
  ) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/api/player/recap/spotify',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(bytes, filename: filename),
        }),
        // anos de histórico podem ser centenas de milhares de linhas
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
      return r.data ?? const {};
    } on DioException catch (e) {
      final err = (e.response?.data is Map)
          ? (e.response!.data as Map)['error']
          : null;
      throw CatalogException(err?.toString() ?? appL10n.apiExtrasNoResponse);
    }
  }

  Future<int> removeSpotifyHistory() async =>
      ((await _send('DELETE', '/api/player/recap/spotify'))['removed'] as num?)
          ?.toInt() ??
      0;

  // ---------- qualidade dos álbuns ----------

  Future<ArtistQuality> quality(String artistName) async {
    final d = await _get('/api/player/quality', {'name': artistName});
    return ArtistQuality(d['name'] as String? ?? artistName, [
      for (final a in (d['albums'] as List? ?? const []))
        if (a is Map<String, dynamic>) AlbumQuality.fromJson(a),
    ], (d['poor'] as num?)?.toInt() ?? 0);
  }

  Future<void> flac(String artist, String folder) =>
      _send('POST', '/api/player/flac', {'artist': artist, 'album': folder});

  Future<void> improve(String artist) =>
      _send('POST', '/api/player/improve', {'artist': artist});

  // ---------- atualização do app ----------

  /// {build, notes, apk: {sha256, size}, windows: {...}} do painel.
  Future<Map<String, dynamic>> updateInfo() => _get('/api/player/update');

  /// Baixa o instalador ("apk" ou "windows") para [path].
  Future<void> downloadUpdate(
    String kind,
    String path, {
    void Function(int got, int total)? onProgress,
  }) => _dio.download(
    '/api/player/update/$kind',
    path,
    onReceiveProgress: onProgress,
    options: Options(receiveTimeout: const Duration(minutes: 10)),
  );

  // ---------- escolher álbuns (MusicBrainz, igual ao "Escolher" do painel) ----------

  /// Começa a conferir a discografia; devolve o token para [albumPlan].
  Future<String> startAlbumPlan(String artist) async =>
      '${(await _send('POST', '/api/player/albums/plan', {'artist': artist}))['token']}';

  /// null enquanto ainda está conferindo.
  Future<AlbumPlan?> albumPlan(String token) async {
    final d = await _get('/api/player/albums/plan/$token');
    if (d['status'] == 'buscando') return null;
    if (d['status'] == 'erro' || d['error'] != null) {
      throw CatalogException('${d['error'] ?? appL10n.apiAlbumListFailed}');
    }
    return AlbumPlan.fromJson(d['result'] as Map<String, dynamic>);
  }

  Future<void> getAlbums(AlbumPlan plan, List<PlanAlbum> picked) =>
      _send('POST', '/api/player/albums/get', {
        'artist': plan.query,
        'name': plan.artist,
        'rgids': [for (final a in picked) a.rgid],
        'titles': [for (final a in picked) '${a.year} - ${a.title}'],
      });

  // ---------- controles dos downloads ----------

  Future<JobDetail> job(String id) async {
    final d = await _get('/api/player/jobs/$id');
    return JobDetail(
      d['status'] as String? ?? '',
      d['summary'] as String?,
      [
        for (final a in (d['albums'] as List? ?? const []))
          if (a is Map) '${a['title']}',
      ],
      [
        for (final l in (d['log'] as List? ?? const []))
          if (l is Map) '${l['x']}',
      ],
    );
  }

  Future<void> cancelJob(String id) =>
      _send('POST', '/api/player/jobs/$id/cancel');
  Future<void> retryJob(String id) =>
      _send('POST', '/api/player/jobs/$id/retry');
  Future<void> deleteJob(String id) => _send('DELETE', '/api/player/jobs/$id');

  // ---------- playlists prontas ----------

  Future<List<Item>> featured() async =>
      _items((await _get('/api/player/featured'))['playlists']);

  /// Cria a playlist na Sua Biblioteca e baixa o que falta. Devolve o texto do aviso.
  Future<String> savePlaylist(int deezerId, {String? cover}) async {
    final d = await _send('POST', '/api/player/playlist/save', {
      'deezer_id': deezerId,
      'cover': ?cover,
    });
    final n = (d['downloading'] as num?)?.toInt() ?? 0;
    final found = (d['found'] as num?)?.toInt() ?? 0;
    final total = (d['total'] as num?)?.toInt() ?? 0;
    return n == 0
        ? appL10n.apiPlaylistSaved(found, total)
        : appL10n.apiPlaylistDownloading(n);
  }

  // ---------- descobertas e mistura ----------

  Future<(MixInfo, MixInfo)> mixes() async {
    final d = await _get('/api/player/mixes');
    return (
      MixInfo.fromJson(
        (d['descobertas'] as Map<String, dynamic>?) ?? const {},
        mistura: false,
      ),
      MixInfo.fromJson(
        (d['mistura'] as Map<String, dynamic>?) ?? const {},
        mistura: true,
      ),
    );
  }

  Future<void> runMix(String kind) => _send('POST', '/api/player/mixes/$kind');

  // ---------- avisos ----------

  Future<(List<Notice>, double)> notices(double since) async {
    final d = await _get('/api/player/notices', {'since': '$since'});
    return (
      [
        for (final n in (d['notices'] as List? ?? const []))
          if (n is Map)
            Notice(
              (n['ts'] as num).toDouble(),
              '${n['title']}',
              '${n['body']}',
              '${n['tag']}',
            ),
      ],
      (d['now'] as num?)?.toDouble() ?? since,
    );
  }

  // ---------- retrospectiva ----------

  Future<(List<int>, Map<String, dynamic>?)> recap({int? year}) async {
    final d = await _get('/api/player/recap', {'year': ?year?.toString()});
    return (
      [for (final y in (d['years'] as List? ?? const [])) (y as num).toInt()],
      d['recap'] as Map<String, dynamic>?,
    );
  }

  /// Capa (tipo=capa) ou foto do artista (tipo=artista) da retrospectiva; leva o token na URL.
  String recapImage({
    required String tipo,
    String? item,
    String? artista,
    String? album,
  }) => Uri.parse('${_dio.options.baseUrl}/api/player/recap/img')
      .replace(
        queryParameters: {
          'tipo': tipo,
          'item': ?item,
          'artista': ?artista,
          'album': ?album,
          'api_key': token,
        },
      )
      .toString();

  Future<List<DownloadJob>> jobs() async {
    final d = await _get('/api/player/jobs');
    return ((d['jobs'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DownloadJob.fromJson)
        .toList();
  }
}

// ---------- perfil, contatos e conversa ----------

/// Outra conta do Jellyfin (contato).
class Contact {
  final String id, name, displayName;

  /// Tag da foto do perfil no Jellyfin (null = sem foto).
  final String? image;
  const Contact(this.id, this.name, this.displayName, {this.image});
  factory Contact.fromJson(Map<String, dynamic> j) => Contact(
    '${j['id']}',
    '${j['name'] ?? ''}',
    '${j['display_name'] ?? j['name'] ?? ''}',
    image: j['image'] is String ? j['image'] as String : null,
  );
}

/// Página compartilhada numa mensagem (música, álbum, artista ou playlist).
class SharedItem {
  final String kind, id, title, subtitle;

  /// URL da capa (catálogo) ou `jf:ID` para a capa da biblioteca.
  final String cover;
  const SharedItem(this.kind, this.id, this.title, this.subtitle, this.cover);
  factory SharedItem.fromJson(Map<String, dynamic> j) => SharedItem(
    '${j['kind'] ?? ''}',
    '${j['id'] ?? ''}',
    '${j['title'] ?? ''}',
    '${j['subtitle'] ?? ''}',
    '${j['cover'] ?? ''}',
  );
  Map<String, dynamic> toJson() => {
    'kind': kind,
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'cover': cover,
  };
}

class ChatMessage {
  final int id;
  final DateTime at;
  final String from, to, text;
  final SharedItem? share;
  final bool read;
  const ChatMessage(
    this.id,
    this.at,
    this.from,
    this.to,
    this.text,
    this.share,
    this.read,
  );
  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    (j['id'] as num).toInt(),
    DateTime.fromMillisecondsSinceEpoch(((j['ts'] as num) * 1000).round()),
    '${j['from']}',
    '${j['to']}',
    '${j['text'] ?? ''}',
    j['share'] is Map<String, dynamic>
        ? SharedItem.fromJson(j['share'] as Map<String, dynamic>)
        : null,
    j['read'] == true,
  );
}

class ChatSummary {
  final Contact user;
  final ChatMessage last;
  final int unread;
  const ChatSummary(this.user, this.last, this.unread);
}

class ChatList {
  final List<ChatSummary> chats;
  final int unread, lastId;
  const ChatList(this.chats, this.unread, this.lastId);
  static const empty = ChatList([], 0, 0);
}

extension SocialApi on Catalog {
  Future<Contact> me() async => Contact.fromJson(await _get('/api/player/me'));

  Future<void> saveDisplayName(String name) =>
      _send('POST', '/api/player/me', {'display_name': name});

  /// Troca o nome de usuário no Jellyfin (o painel leva junto o que guarda pelo nome).
  Future<String> renameUser(String name) async =>
      '${(await _send('POST', '/api/player/me/username', {'name': name}))['name'] ?? name}';

  Future<List<Contact>> contacts() async => [
    for (final c
        in ((await _get('/api/player/contacts'))['contacts'] as List? ??
            const []))
      if (c is Map<String, dynamic>) Contact.fromJson(c),
  ];

  Future<ChatList> chats() async {
    final d = await _get('/api/player/chats');
    return ChatList(
      [
        for (final c in (d['chats'] as List? ?? const []))
          if (c is Map<String, dynamic>)
            ChatSummary(
              Contact.fromJson(c['user'] as Map<String, dynamic>),
              ChatMessage.fromJson(c['last'] as Map<String, dynamic>),
              (c['unread'] as num?)?.toInt() ?? 0,
            ),
      ],
      (d['unread'] as num?)?.toInt() ?? 0,
      (d['last_id'] as num?)?.toInt() ?? 0,
    );
  }

  /// Mensagens com [userId] depois de [after] (e marca as recebidas como lidas).
  Future<(Contact, List<ChatMessage>)> chat(
    String userId, {
    int after = 0,
  }) async {
    final d = await _get('/api/player/chat/$userId', {'after': '$after'});
    return (
      Contact.fromJson(d['user'] as Map<String, dynamic>),
      [
        for (final m in (d['messages'] as List? ?? const []))
          if (m is Map<String, dynamic>) ChatMessage.fromJson(m),
      ],
    );
  }

  Future<ChatMessage> sendChat(
    String userId, {
    String text = '',
    SharedItem? share,
  }) async {
    final d = await _send('POST', '/api/player/chat/$userId', {
      'text': text,
      'share': ?share?.toJson(),
    });
    return ChatMessage.fromJson(d['message'] as Map<String, dynamic>);
  }
}

// ---------- shows (MusicBrainz) ----------

class ShowEvent {
  final String id, date, time, name, type, place, city, country, artist, url;
  final String? artistId;
  final bool cancelled;
  const ShowEvent({
    required this.id,
    required this.date,
    required this.time,
    required this.name,
    required this.type,
    required this.place,
    required this.city,
    required this.country,
    required this.artist,
    required this.url,
    this.artistId,
    this.cancelled = false,
  });
  DateTime get day => DateTime.tryParse(date) ?? DateTime(1970);
  factory ShowEvent.fromJson(Map<String, dynamic> j) => ShowEvent(
    id: '${j['id']}',
    date: '${j['date'] ?? ''}',
    time: '${j['time'] ?? ''}',
    name: '${j['name'] ?? ''}',
    type: '${j['type'] ?? ''}',
    place: '${j['place'] ?? ''}',
    city: '${j['city'] ?? ''}',
    country: '${j['country'] ?? ''}',
    artist: '${j['artist'] ?? ''}',
    url: '${j['url'] ?? ''}',
    artistId: j['artist_id'] as String?,
    cancelled: j['cancelled'] == true,
  );
}

class ShowsData {
  final List<ShowEvent> upcoming, past;
  final int following, pending;
  const ShowsData(this.upcoming, this.past, this.following, this.pending);
}

// ---------- podcasts ----------

class PodcastShow {
  final String id, title, author, cover, genre, description;
  const PodcastShow(
    this.id,
    this.title,
    this.author,
    this.cover, {
    this.genre = '',
    this.description = '',
  });
  factory PodcastShow.fromJson(Map<String, dynamic> j) => PodcastShow(
    '${j['id']}',
    '${j['title'] ?? ''}',
    '${j['author'] ?? ''}',
    '${j['cover'] ?? ''}',
    genre: '${j['genre'] ?? ''}',
    description: '${j['description'] ?? ''}',
  );
}

class PodcastEpisode {
  final String guid, title, url, image, description, podcast, podcastId;
  final DateTime? date;
  final Duration duration;
  final Duration position;
  final bool done;
  const PodcastEpisode({
    required this.guid,
    required this.title,
    required this.url,
    required this.image,
    required this.description,
    required this.podcast,
    required this.podcastId,
    this.date,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.done = false,
  });
  factory PodcastEpisode.fromJson(
    Map<String, dynamic> j, {
    String podcast = '',
    String podcastId = '',
    String cover = '',
  }) {
    final p = j['progress'] as Map<String, dynamic>?;
    final ts = (j['date'] as num?)?.toDouble() ?? 0;
    final img = '${j['image'] ?? ''}';
    return PodcastEpisode(
      guid: '${j['guid']}',
      title: '${j['title'] ?? ''}',
      url: '${j['url'] ?? ''}',
      image: img.isNotEmpty ? img : '${j['cover'] ?? cover}',
      description: '${j['description'] ?? ''}',
      podcast: '${j['podcast'] ?? podcast}',
      podcastId: '${j['podcast_id'] ?? podcastId}',
      date: ts > 0
          ? DateTime.fromMillisecondsSinceEpoch((ts * 1000).round())
          : null,
      duration: Duration(seconds: (j['duration'] as num?)?.toInt() ?? 0),
      position: Duration(seconds: ((p?['pos'] as num?) ?? 0).toInt()),
      done: p?['done'] == true,
    );
  }

  /// Vira uma faixa da fila do player (toca direto do endereço do episódio).
  Item toItem() {
    final id = 'pod$guid';
    if (image.isNotEmpty) catalogCovers[id] = image;
    return Item(
      id: id,
      name: title,
      kind: ItemKind.track,
      album: podcast,
      albumId: 'podshow$podcastId',
      artists: [NameId('', podcast)],
      duration: duration,
      primaryTag: 'pod',
      streamUrl: url,
    );
  }
}

class PodcastPage {
  final PodcastShow show;
  final List<PodcastEpisode> episodes;
  final bool subscribed;

  /// Quantos episódios o feed tem (com o filtro, se houver) e de onde pedir a próxima página (null = acabou).
  final int total;
  final int? nextOffset;
  const PodcastPage(
    this.show,
    this.episodes,
    this.subscribed, {
    this.total = 0,
    this.nextOffset,
  });
}

extension MediaApi on Catalog {
  /// Artistas seguidos que ainda não estão na biblioteca (sem álbum baixado). O painel guarda por conta e,
  /// quando o artista chega ao Jellyfin, passa o "seguir" para lá sozinho.
  Future<List<Item>> followedArtists() async {
    final d = await _get('/api/player/follows');
    return [
      for (final a in (d['artists'] as List? ?? const []))
        if (a is Map<String, dynamic>)
          Item.fromCatalog({
            'kind': 'artist',
            'deezer_id': a['deezer_id'],
            'title': a['name'],
            if ((a['cover'] as String? ?? '').isNotEmpty) 'cover': a['cover'],
          }).copyWith(favorite: true),
    ];
  }

  Future<void> followArtist(Item a, bool on) => _send(
    on ? 'POST' : 'DELETE',
    '/api/player/follows/${catalogNumber(a.id)}',
    on ? {'name': a.name, 'cover': catalogCovers[a.id]} : null,
  );

  Future<ShowsData> shows() async {
    final d = await _get('/api/player/shows');
    List<ShowEvent> list(String k) => [
      for (final e in (d[k] as List? ?? const []))
        if (e is Map<String, dynamic>) ShowEvent.fromJson(e),
    ];
    return ShowsData(
      list('upcoming'),
      list('past'),
      (d['following'] as num?)?.toInt() ?? 0,
      (d['pending'] as num?)?.toInt() ?? 0,
    );
  }

  List<PodcastShow> _shows(Object? l) => [
    for (final s in (l as List? ?? const []))
      if (s is Map<String, dynamic>) PodcastShow.fromJson(s),
  ];

  Future<List<PodcastShow>> podcastSearch(String q) async =>
      _shows((await _get('/api/player/podcasts/search', {'q': q}))['results']);

  Future<List<PodcastShow>> podcastTop() async =>
      _shows((await _get('/api/player/podcasts/top'))['results']);

  Future<List<PodcastShow>> podcastSubs() async =>
      _shows((await _get('/api/player/podcasts/subs'))['subs']);

  Future<void> podcastSubscribe(String id, bool on) =>
      _send(on ? 'POST' : 'DELETE', '/api/player/podcasts/subs/$id');

  /// Uma página de episódios (o painel lê o RSS só quando alguém abre o podcast e entrega de [limit] em [limit]).
  Future<PodcastPage> podcast(
    String id, {
    int offset = 0,
    int limit = 20,
    String q = '',
  }) async {
    final qs = Uri(
      queryParameters: {
        'offset': '$offset',
        'limit': '$limit',
        if (q.isNotEmpty) 'q': q,
      },
    ).query;
    final d = await _get('/api/player/podcasts/show/$id?$qs');
    final show = PodcastShow.fromJson(d);
    return PodcastPage(
      show,
      [
        for (final e in (d['episodes'] as List? ?? const []))
          if (e is Map<String, dynamic>)
            PodcastEpisode.fromJson(
              e,
              podcast: show.title,
              podcastId: show.id,
              cover: show.cover,
            ),
      ],
      d['subscribed'] == true,
      total: (d['total'] as num?)?.toInt() ?? 0,
      nextOffset: (d['next_offset'] as num?)?.toInt(),
    );
  }

  Future<List<PodcastEpisode>> podcastLatest() async {
    final d = await _get('/api/player/podcasts/latest');
    return [
      for (final e in (d['episodes'] as List? ?? const []))
        if (e is Map<String, dynamic>) PodcastEpisode.fromJson(e),
    ];
  }

  Future<void> podcastProgress(
    String guid,
    String podcastId,
    Duration pos,
    Duration dur,
  ) => _send('POST', '/api/player/podcasts/progress', {
    'guid': guid,
    'pid': podcastId,
    'pos': pos.inSeconds,
    'dur': dur.inSeconds,
  });
}

// ---------- Radar, daylist e Blend (playlists montadas pelo painel) ----------

/// Radar de Novidades ou daylist da conta.
class MadeInfo {
  final String? playlist, name, note, error;
  final int tracks;
  final bool running;
  final DateTime? generated;
  const MadeInfo({
    this.playlist,
    this.name,
    this.note,
    this.error,
    this.tracks = 0,
    this.running = false,
    this.generated,
  });
  factory MadeInfo.fromJson(Map<String, dynamic>? j) => j == null
      ? const MadeInfo()
      : MadeInfo(
          playlist: j['playlist'] as String?,
          name: j['name'] as String?,
          note: j['note'] as String?,
          error: j['error'] as String?,
          tracks: (j['tracks'] as num?)?.toInt() ?? 0,
          running: j['running'] == true,
          generated: _epoch(j['generated']),
        );
}

DateTime? _epoch(Object? v) =>
    v is num ? DateTime.fromMillisecondsSinceEpoch((v * 1000).round()) : null;

class BlendInfo {
  final String userId, name;
  final int? affinity;
  final List<String> common;
  final String? playlist, error;
  final int tracks;
  final bool running;
  const BlendInfo({
    required this.userId,
    required this.name,
    this.affinity,
    this.common = const [],
    this.playlist,
    this.error,
    this.tracks = 0,
    this.running = false,
  });
  factory BlendInfo.fromJson(Map<String, dynamic> j) => BlendInfo(
    userId: '${j['user_id'] ?? ''}',
    name: '${j['name'] ?? ''}',
    affinity: (j['affinity'] as num?)?.toInt(),
    common: [for (final c in (j['common'] as List? ?? const [])) '$c'],
    playlist: j['playlist'] as String?,
    error: j['error'] as String?,
    tracks: (j['tracks'] as num?)?.toInt() ?? 0,
    running: j['running'] == true,
  );
}

class MadeData {
  final MadeInfo radar, daylist;
  final List<BlendInfo> blends;
  const MadeData(this.radar, this.daylist, this.blends);
  BlendInfo? blendWith(String userId) =>
      blends.where((b) => b.userId == userId).firstOrNull;
}

// ---------- Jam ----------

class JamState {
  final String id, host, context;
  final bool isHost, playing, ended;
  final int rev, index, posMs;
  final List<Contact> members;

  /// null quando não mudou desde o último rev pedido.
  final List<Item>? queue;
  final List<Item> pending;
  final List<Map<String, dynamic>> cmds;
  const JamState({
    required this.id,
    required this.host,
    required this.context,
    required this.isHost,
    required this.playing,
    required this.ended,
    required this.rev,
    required this.index,
    required this.posMs,
    required this.members,
    this.queue,
    this.pending = const [],
    this.cmds = const [],
  });

  static Item _item(Map<String, dynamic> x) {
    try {
      return Item.fromStore(x);
    } catch (_) {
      return Item(id: '${x['id']}', name: '', kind: ItemKind.track);
    }
  }

  factory JamState.fromJson(Map<String, dynamic> j) {
    List<Item> items(Object? l) => [
      for (final x in (l as List? ?? const []))
        if (x is Map<String, dynamic>) _item(x),
    ];
    return JamState(
      id: '${j['id']}',
      host: '${j['host']}',
      context: '${j['context'] ?? ''}',
      isHost: j['is_host'] == true,
      playing: j['playing'] == true,
      ended: j['ended'] == true,
      rev: (j['rev'] as num?)?.toInt() ?? 0,
      index: (j['index'] as num?)?.toInt() ?? 0,
      posMs: (j['pos_ms'] as num?)?.toInt() ?? 0,
      members: [
        for (final m in (j['members'] as List? ?? const []))
          if (m is Map<String, dynamic>) Contact.fromJson(m),
      ],
      queue: j.containsKey('queue') ? items(j['queue']) : null,
      pending: items(j['pending']),
      cmds: [
        for (final c in (j['cmds'] as List? ?? const []))
          if (c is Map<String, dynamic>) c,
      ],
    );
  }
}

class CollabInfo {
  final String? owner;
  final List<Contact> members;

  /// id da faixa -> id de quem adicionou.
  final Map<String, String> added;
  const CollabInfo(this.owner, this.members, this.added);
  static const none = CollabInfo(null, [], {});
  bool get isCollab => members.length > 1;
  Contact? who(String itemId) {
    final u = added[itemId];
    return u == null ? null : members.where((m) => m.id == u).firstOrNull;
  }
}

class LastfmStatus {
  final bool configured, connected;
  final String? name;
  const LastfmStatus(this.configured, this.connected, this.name);
}

extension PudimExtrasApi on Catalog {
  Future<MadeData> made() async {
    final d = await _get('/api/player/made');
    return MadeData(
      MadeInfo.fromJson(d['radar'] as Map<String, dynamic>?),
      MadeInfo.fromJson(d['daylist'] as Map<String, dynamic>?),
      [
        for (final b in (d['blends'] as List? ?? const []))
          if (b is Map<String, dynamic>) BlendInfo.fromJson(b),
      ],
    );
  }

  /// kind: radar | daylist.
  Future<void> runMade(String kind) => _send('POST', '/api/player/made/$kind');

  Future<void> makeBlend(String userId) =>
      _send('POST', '/api/player/blend/$userId');

  Future<void> deleteBlend(String userId) =>
      _send('DELETE', '/api/player/blend/$userId');

  // Jam
  Future<JamState?> jam({int? rev}) async {
    final d = await _get('/api/player/jam', {if (rev != null) 'rev': '$rev'});
    final j = d['jam'];
    return j is Map<String, dynamic> ? JamState.fromJson(j) : null;
  }

  Future<JamState> startJam(Map<String, dynamic> state) async =>
      JamState.fromJson(
        (await _send('POST', '/api/player/jam', state))['jam']
            as Map<String, dynamic>,
      );

  Future<JamState> joinJam(String id) async => JamState.fromJson(
    (await _send('POST', '/api/player/jam/$id/join'))['jam']
        as Map<String, dynamic>,
  );

  Future<void> leaveJam(String id) =>
      _send('POST', '/api/player/jam/$id/leave');

  Future<JamState> pushJam(String id, Map<String, dynamic> state) async =>
      JamState.fromJson(
        (await _send('POST', '/api/player/jam/$id/state', state))['jam']
            as Map<String, dynamic>,
      );

  Future<void> jamAdd(String id, List<Item> items) =>
      _send('POST', '/api/player/jam/$id/add', {
        'items': [for (final i in items) i.toStore()],
      });

  Future<void> jamCmd(String id, String action, {int? index}) => _send(
    'POST',
    '/api/player/jam/$id/cmd',
    {'action': action, 'index': ?index},
  );

  Future<void> jamInvite(String id, String userId) =>
      _send('POST', '/api/player/jam/$id/invite/$userId');

  // Colaborativas
  Future<CollabInfo> collab(String pid) async {
    final d = await _get('/api/player/collab/$pid');
    return CollabInfo(
      d['owner'] as String?,
      [
        for (final m in (d['members'] as List? ?? const []))
          if (m is Map<String, dynamic>) Contact.fromJson(m),
      ],
      {
        for (final e in ((d['added'] as Map?) ?? const {}).entries)
          '${e.key}': '${e.value}',
      },
    );
  }

  Future<void> collabInvite(String pid, String userId, String title) =>
      _send('POST', '/api/player/collab/$pid/invite/$userId', {'title': title});

  Future<void> collabAdded(String pid, List<String> ids) =>
      _send('POST', '/api/player/collab/$pid/added', {'ids': ids});

  // Last.fm
  Future<LastfmStatus> lastfm() async {
    final d = await _get('/api/player/lastfm');
    return LastfmStatus(
      d['configured'] == true,
      d['connected'] == true,
      d['name'] as String?,
    );
  }

  Future<(String, String)> lastfmConnect() async {
    final d = await _send('POST', '/api/player/lastfm/connect');
    return ('${d['token']}', '${d['url']}');
  }

  Future<String?> lastfmFinish(String token) async =>
      (await _send('POST', '/api/player/lastfm/finish', {
            'token': token,
          }))['name']
          as String?;

  Future<void> lastfmDisconnect() => _send('DELETE', '/api/player/lastfm');

  Future<void> scrobble(Item t, {required bool nowPlaying, DateTime? at}) =>
      _send('POST', '/api/player/scrobble', {
        'artist': t.mainArtist?.name ?? t.artistLine,
        'track': t.name,
        'album': ?t.album,
        'duration': t.duration.inSeconds,
        'now_playing': nowPlaying,
        if (at != null) 'timestamp': at.millisecondsSinceEpoch ~/ 1000,
      });
}
