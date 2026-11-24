import 'package:dio/dio.dart';

import 'models.dart';
import 'response_cache.dart';

import 'dart:convert';

import '../l10n/l10n.dart';

const appName = 'Pudim';
const appVersion = '0.2.0';

/// Fields requested in every item list.
// Only valid ItemFields values: /Items ignores unknown ones, but
// /InstantMix answers 400 (SongCount and ProductionYear always come anyway).
const _fields =
    'PrimaryImageAspectRatio,ChildCount,DateCreated,Overview,ParentId';

class AuthResult {
  final String token;
  final String userId;
  final String userName;
  const AuthResult(this.token, this.userId, this.userName);
}

class JellyfinException implements Exception {
  final String message;
  JellyfinException(this.message);
  @override
  String toString() => message;
}

/// Hand-written Jellyfin client: only the endpoints the app uses.
class Jellyfin {
  /// Changes when the device switches networks (home ↔ away); see [switchTo].
  String baseUrl;
  final String deviceId;
  final String deviceName;
  String? token;
  String? userId;
  late final Dio _dio;

  /// On-device copy of responses (the app works without internet with what it already opened).
  final ResponseCache? cache;

  Jellyfin({
    required this.baseUrl,
    required this.deviceId,
    required this.deviceName,
    this.token,
    this.userId,
    HttpClientAdapter? adapter,
    this.cache,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    if (adapter != null) _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          o.headers['Authorization'] = authHeader;
          h.next(o);
        },
      ),
    );
    if (cache != null) _dio.interceptors.add(cache!.interceptor());
  }

  String get authHeader {
    final parts = [
      'Client="$appName"',
      'Device="${deviceName.replaceAll('"', '')}"',
      'DeviceId="$deviceId"',
      'Version="$appVersion"',
      if (token != null) 'Token="$token"',
    ];
    return 'MediaBrowser ${parts.join(', ')}';
  }

  /// Starts talking to another address of the same server (e.g. left the home Wi-Fi).
  void switchTo(String url) {
    baseUrl = url;
    _dio.options.baseUrl = url;
  }

  /// Checks whether the server responds (used to choose LAN or the outside address).
  /// The outside one goes through the tunnel and, on 4G, can take a few seconds.
  static Future<bool> reachable(
    String url, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      final r = await Dio(
        BaseOptions(connectTimeout: timeout, receiveTimeout: timeout),
      ).get('$url/System/Info/Public');
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<AuthResult> login(String user, String password) async {
    try {
      final r = await _dio.post(
        '/Users/AuthenticateByName',
        data: {'Username': user, 'Pw': password},
      );
      final d = r.data as Map<String, dynamic>;
      final u = d['User'] as Map<String, dynamic>;
      token = d['AccessToken'] as String;
      userId = u['Id'] as String;
      return AuthResult(token!, userId!, u['Name'] as String? ?? user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw JellyfinException(appL10n.apiBadCredentials);
      }
      throw JellyfinException(appL10n.apiServerUnreachable);
    }
  }

  // ---------- Quick Connect (sign in with a code, approved in an already signed-in app) ----------

  Future<bool> quickConnectEnabled() async {
    try {
      final r = await _dio.get('/QuickConnect/Enabled');
      return r.data == true;
    } catch (_) {
      return false;
    }
  }

  /// Requests a new code: returns (secret, 6-digit code to display).
  Future<(String, String)> quickConnectStart() async {
    try {
      final r = await _dio.post('/QuickConnect/Initiate');
      final d = r.data as Map<String, dynamic>;
      return (d['Secret'] as String, d['Code'] as String);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw JellyfinException(appL10n.apiQuickConnectOff);
      }
      throw JellyfinException(appL10n.apiServerUnreachable);
    }
  }

  /// Has the code been approved on another device yet?
  Future<bool> quickConnectApproved(String secret) async {
    final r = await _dio.get(
      '/QuickConnect/Connect',
      queryParameters: {'secret': secret},
    );
    return (r.data as Map<String, dynamic>)['Authenticated'] == true;
  }

  Future<AuthResult> loginQuickConnect(String secret) async {
    final r = await _dio.post(
      '/Users/AuthenticateWithQuickConnect',
      data: {'Secret': secret},
    );
    final d = r.data as Map<String, dynamic>;
    final u = d['User'] as Map<String, dynamic>;
    token = d['AccessToken'] as String;
    userId = u['Id'] as String;
    return AuthResult(token!, userId!, u['Name'] as String? ?? '');
  }

  Future<void> logout() async {
    try {
      await _dio.post('/Sessions/Logout');
    } catch (_) {}
  }

  // ---------- lists ----------

  Future<List<Item>> items(Map<String, dynamic> query) async {
    final r = await _dio.get(
      '/Items',
      queryParameters: {
        'userId': userId,
        'Fields': _fields,
        'EnableUserData': true,
        'EnableImageTypes': 'Primary,Backdrop',
        ...query,
      },
    );
    return _list(r.data);
  }

  List<Item> _list(dynamic data) {
    final raw = data is List ? data : (data as Map)['Items'] as List? ?? [];
    return raw.whereType<Map<String, dynamic>>().map(Item.fromJson).toList();
  }

  /// Profile photo of an account (public in Jellyfin); [tag] changes when the photo changes.
  String userImageUrl(String userId, String tag, {int size = 160}) =>
      '$baseUrl/Users/$userId/Images/Primary?maxWidth=$size&quality=90&tag=$tag';

  /// Photo tag of this account (null = no photo).
  Future<String?> myImageTag() async {
    final r = await _dio.get('/Users/$userId');
    return (r.data as Map<String, dynamic>)['PrimaryImageTag'] as String?;
  }

  /// Replaces the profile photo (Jellyfin wants the image as base64).
  Future<void> setMyImage(List<int> bytes, String mime) async {
    await _dio.post(
      '/Users/$userId/Images/Primary',
      data: base64Encode(bytes),
      options: Options(contentType: mime),
    );
  }

  Future<void> deleteMyImage() async {
    await _dio.delete('/Users/$userId/Images/Primary');
  }

  /// Changes this account's password (Jellyfin checks the current password).
  Future<void> changePassword(String current, String next) async {
    try {
      await _dio.post(
        '/Users/$userId/Password',
        data: {'CurrentPw': current, 'NewPw': next},
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      throw JellyfinException(
        code == 401 || code == 403
            ? appL10n.apiWrongCurrentPassword
            : appL10n.apiServerUnreachable,
      );
    }
  }

  Future<Item> item(String id) async {
    final r = await _dio.get('/Items/$id', queryParameters: {'userId': userId});
    return Item.fromJson(r.data as Map<String, dynamic>);
  }

  Future<List<Item>> recentlyPlayedTracks({int limit = 30}) => items({
    'IncludeItemTypes': 'Audio',
    'Recursive': true,
    'Filters': 'IsPlayed',
    'SortBy': 'DatePlayed',
    'SortOrder': 'Descending',
    'Limit': limit,
  });

  Future<List<Item>> mostPlayedTracks({int limit = 50}) => items({
    'IncludeItemTypes': 'Audio',
    'Recursive': true,
    'Filters': 'IsPlayed',
    'SortBy': 'PlayCount',
    'SortOrder': 'Descending',
    'Limit': limit,
  });

  String? _musicViewId;

  /// Id of the user's "Music" library (/Items/Latest needs it:
  /// with IncludeItemTypes and no ParentId it comes back empty).
  Future<String?> musicViewId() async {
    if (_musicViewId != null) return _musicViewId;
    final r = await _dio.get('/UserViews', queryParameters: {'userId': userId});
    for (final v in (r.data as Map)['Items'] as List? ?? const []) {
      if (v is Map && v['CollectionType'] == 'music') {
        return _musicViewId = v['Id'] as String?;
      }
    }
    return null;
  }

  Future<List<Item>> latestAlbums({int limit = 20}) async {
    final parent = await musicViewId();
    final r = await _dio.get(
      '/Items/Latest',
      queryParameters: {
        'userId': userId,
        'ParentId': ?parent,
        'Limit': limit,
        'Fields': _fields,
        'GroupItems': true,
      },
    );
    return _list(r.data);
  }

  Future<List<Item>> playlists() => items({
    'IncludeItemTypes': 'Playlist',
    'Recursive': true,
    'SortBy': 'SortName',
    'MediaTypes': 'Audio',
  });

  // ---------- edit playlists (the user's own and those shared with edit permission) ----------

  /// Creates a private playlist for this account; returns the id.
  Future<String> createPlaylist(String name, List<String> ids) async {
    final r = await _dio.post(
      '/Playlists',
      data: {
        'Name': name,
        'Ids': ids,
        'UserId': userId,
        'MediaType': 'Audio',
        'IsPublic': false,
      },
    );
    return (r.data as Map<String, dynamic>)['Id'] as String;
  }

  Future<void> addToPlaylist(String playlistId, List<String> ids) async {
    for (var i = 0; i < ids.length; i += 100) {
      await _dio.post(
        '/Playlists/$playlistId/Items',
        queryParameters: {
          'ids': ids.skip(i).take(100).join(','),
          'userId': userId,
        },
      );
    }
  }

  /// [entryIds] = PlaylistItemId of each track in the playlist.
  Future<void> removeFromPlaylist(String playlistId, List<String> entryIds) =>
      _dio.delete(
        '/Playlists/$playlistId/Items',
        queryParameters: {'entryIds': entryIds.join(',')},
      );

  /// Grants access to another account (only the owner can; the panel has no way to do it for them).
  Future<void> sharePlaylist(
    String playlistId,
    String otherUserId, {
    bool canEdit = false,
  }) => _dio.post(
    '/Playlists/$playlistId/Users/$otherUserId',
    data: {'CanEdit': canEdit},
  );

  Future<List<Item>> favoriteAlbums() => items({
    'IncludeItemTypes': 'MusicAlbum',
    'Recursive': true,
    'Filters': 'IsFavorite',
    'SortBy': 'SortName',
  });

  Future<List<Item>> favoriteArtists() async {
    final r = await _dio.get(
      '/Artists',
      queryParameters: {
        'userId': userId,
        'IsFavorite': true,
        'Fields': _fields,
        'SortBy': 'SortName',
        'EnableImageTypes': 'Primary,Backdrop',
      },
    );
    return _list(r.data);
  }

  Future<List<Item>> favoriteTracks() => items({
    'IncludeItemTypes': 'Audio',
    'Recursive': true,
    'Filters': 'IsFavorite',
    'SortBy': 'DateCreated',
    'SortOrder': 'Descending',
  });

  Future<List<Item>> albumTracks(String albumId) => items({
    'ParentId': albumId,
    'IncludeItemTypes': 'Audio',
    'Recursive': true,
    'SortBy': 'ParentIndexNumber,IndexNumber,SortName',
  });

  Future<List<Item>> playlistTracks(String playlistId) async {
    final r = await _dio.get(
      '/Playlists/$playlistId/Items',
      queryParameters: {
        'userId': userId,
        'Fields': _fields,
        'EnableUserData': true,
      },
    );
    return _list(r.data);
  }

  Future<List<Item>> artistAlbums(String artistId) => items({
    'AlbumArtistIds': artistId,
    'IncludeItemTypes': 'MusicAlbum',
    'Recursive': true,
    'SortBy': 'ProductionYear,SortName',
    'SortOrder': 'Descending',
  });

  Future<List<Item>> appearsOn(String artistId) => items({
    'ContributingArtistIds': artistId,
    'IncludeItemTypes': 'MusicAlbum',
    'Recursive': true,
    'SortBy': 'ProductionYear',
    'SortOrder': 'Descending',
    'Limit': 20,
  });

  Future<List<Item>> artistTopTracks(String artistId, {int limit = 10}) =>
      items({
        'ArtistIds': artistId,
        'IncludeItemTypes': 'Audio',
        'Recursive': true,
        'SortBy': 'PlayCount,SortName',
        'SortOrder': 'Descending',
        'Limit': limit,
      });

  Future<List<Item>> artistAllTracks(String artistId) => items({
    'ArtistIds': artistId,
    'IncludeItemTypes': 'Audio',
    'Recursive': true,
    'SortBy': 'Album,ParentIndexNumber,IndexNumber',
  });

  Future<List<Item>> similar(String itemId, {int limit = 12}) async {
    final r = await _dio.get(
      '/Items/$itemId/Similar',
      queryParameters: {'userId': userId, 'Limit': limit, 'Fields': _fields},
    );
    return _list(r.data);
  }

  Future<List<Item>> instantMix(String itemId, {int limit = 60}) async {
    final r = await _dio.get(
      '/Items/$itemId/InstantMix',
      queryParameters: {'userId': userId, 'Limit': limit, 'Fields': _fields},
    );
    return _list(r.data);
  }

  Future<List<Item>> search(String term, String types, {int limit = 20}) =>
      items({
        'searchTerm': term,
        'IncludeItemTypes': types,
        'Recursive': true,
        'Limit': limit,
      });

  Future<List<Item>> searchArtists(String term, {int limit = 12}) async {
    final r = await _dio.get(
      '/Artists',
      queryParameters: {
        'userId': userId,
        'searchTerm': term,
        'Limit': limit,
        'Fields': _fields,
      },
    );
    return _list(r.data);
  }

  // ---------- lyrics ----------

  Future<Lyrics> lyrics(String trackId) async {
    try {
      final r = await _dio.get('/Audio/$trackId/Lyrics');
      return Lyrics.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Lyrics([]);
      rethrow;
    }
  }

  /// Asks the server's lyrics providers for this track and saves the first match next to the
  /// file. Null when the server has no provider, finds nothing or does not allow it.
  Future<Lyrics?> downloadServerLyrics(String trackId) async {
    try {
      final r = await _dio.get('/Audio/$trackId/RemoteSearch/Lyrics');
      final found = (r.data as List?)?.whereType<Map<String, dynamic>>() ?? [];
      if (found.isEmpty) return null;
      final id = found.first['Id'];
      final s = await _dio.post('/Audio/$trackId/RemoteSearch/Lyrics/$id');
      final l = Lyrics.fromJson(s.data as Map<String, dynamic>);
      return l.isEmpty ? null : l;
    } catch (_) {
      return null;
    }
  }

  /// Saves an .lrc text as the track's lyrics on the server (needs the lyrics permission).
  Future<bool> uploadLyrics(String trackId, String lrc) async {
    try {
      await _dio.post(
        '/Audio/$trackId/Lyrics',
        queryParameters: {'fileName': '$trackId.lrc'},
        data: lrc,
        options: Options(contentType: 'text/plain'),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------- favorites ----------

  Future<void> setFavorite(String itemId, bool fav) async {
    final path = '/UserFavoriteItems/$itemId';
    final q = {'userId': userId};
    if (fav) {
      await _dio.post(path, queryParameters: q);
    } else {
      await _dio.delete(path, queryParameters: q);
    }
  }

  // ---------- media ----------

  /// Original file (the library's tracks are already MP3).
  String streamUrl(String trackId) =>
      '$baseUrl/Audio/$trackId/stream?static=true&deviceId=$deviceId&api_key=$token';

  /// For the Chromecast: the file as is when it plays the format (MP3, AAC, FLAC,
  /// Opus, Vorbis, WAV); otherwise, converted to MP3 320 kbps.
  String castUrl(String trackId) =>
      '$baseUrl/Audio/$trackId/universal?userId=$userId&deviceId=$deviceId'
      '&api_key=$token&container=mp3,aac,m4a|aac,flac,opus,webm|opus,ogg|vorbis,wav'
      '&transcodingContainer=mp3&transcodingProtocol=http&audioCodec=mp3'
      '&maxStreamingBitrate=320000';

  /// Lighter version, converted by Jellyfin to AAC at [kbps] (HLS, seeking is possible).
  String transcodeUrl(String trackId, int kbps) {
    final bps = kbps * 1000;
    return '$baseUrl/Audio/$trackId/main.m3u8?mediaSourceId=$trackId'
        '&deviceId=$deviceId&ApiKey=$token&audioCodec=aac&audioBitRate=$bps'
        '&maxStreamingBitrate=$bps&transcodingMaxAudioChannels=2'
        '&segmentContainer=ts&breakOnNonKeyFrames=true'
        '&playSessionId=${DateTime.now().microsecondsSinceEpoch}';
  }

  String? imageUrl(
    String? itemId, {
    String type = 'Primary',
    int size = 300,
    String? tag,
  }) {
    if (itemId == null) return null;
    if (itemId.startsWith('pod')) {
      return type == 'Primary' ? catalogCovers[itemId] : null;
    }
    if (isCatalogId(itemId)) {
      return type == 'Primary' ? catalogCover(itemId, size) : null;
    }
    final t = tag == null ? '' : '&tag=$tag';
    return '$baseUrl/Items/$itemId/Images/$type?maxWidth=$size&quality=90$t';
  }

  // ---------- playback reporting ----------

  Future<void> reportCapabilities() async {
    try {
      await _dio.post(
        '/Sessions/Capabilities/Full',
        data: {
          'PlayableMediaTypes': ['Audio'],
          'SupportedCommands': ['SetVolume', 'Mute', 'Unmute'],
          'SupportsMediaControl': false,
        },
      );
    } catch (_) {}
  }

  Future<void> reportStart(
    String itemId,
    Duration pos, {
    required bool paused,
  }) => _report('/Sessions/Playing', itemId, pos, paused);

  Future<void> reportProgress(
    String itemId,
    Duration pos, {
    required bool paused,
  }) => _report('/Sessions/Playing/Progress', itemId, pos, paused);

  Future<void> reportStopped(String itemId, Duration pos) =>
      _report('/Sessions/Playing/Stopped', itemId, pos, false);

  Future<void> _report(
    String path,
    String itemId,
    Duration pos,
    bool paused,
  ) async {
    try {
      await _dio.post(
        path,
        data: {
          'ItemId': itemId,
          'PositionTicks': durationToTicks(pos),
          'IsPaused': paused,
          'CanSeek': true,
          'PlayMethod': 'DirectPlay',
        },
      );
    } catch (_) {
      // Reporting is best-effort: it never disrupts the music.
    }
  }
}
