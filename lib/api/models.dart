// Minimal Jellyfin models used by PudimMusic.
// Only the fields the app uses; the rest of the JSON is ignored.

import '../l10n/l10n.dart';

const int ticksPerSecond = 10000000;

Duration ticksToDuration(num? ticks) =>
    Duration(microseconds: ((ticks ?? 0) / 10).round());

int durationToTicks(Duration d) => d.inMicroseconds * 10;

class NameId {
  final String id;
  final String name;
  const NameId(this.id, this.name);

  factory NameId.fromJson(Map<String, dynamic> j) =>
      NameId(j['Id'] as String? ?? '', j['Name'] as String? ?? '');
}

enum ItemKind { track, album, artist, playlist, other }

ItemKind _kindOf(String? type) {
  switch (type) {
    case 'Audio':
      return ItemKind.track;
    case 'MusicAlbum':
      return ItemKind.album;
    case 'MusicArtist':
      return ItemKind.artist;
    case 'Playlist':
      return ItemKind.playlist;
    default:
      return ItemKind.other;
  }
}

class Item {
  final String id;
  final String name;
  final ItemKind kind;
  final String? albumId;
  final String? album;
  final List<NameId> artists;
  final List<NameId> albumArtists;
  final Duration duration;
  final String? primaryTag;
  final String? albumPrimaryTag;
  final List<String> backdropTags;
  final int? year;
  final int? index;
  final int? disc;
  final int? childCount;
  final bool favorite;
  final int playCount;
  final String? overview;
  final DateTime? dateCreated;
  final String? playlistItemId;

  /// Catalog only (Deezer), not in the library yet: shows a cloud and plays through the panel.
  final bool cloud;

  /// From the catalog: "album", "single", "ep" or "compile" (to separate Albums from Singles and EPs).
  final String? recordType;

  /// Audio URL outside Jellyfin (podcast episode); the cover is in catalogCovers[id].
  final String? streamUrl;

  /// Gain to bring all tracks to the same volume (dB, computed by Jellyfin; null = not analyzed).
  final double? normalizationGain;

  /// Podcast episode (id "pod…").
  bool get isPodcast => id.startsWith('pod');

  const Item({
    required this.id,
    required this.name,
    required this.kind,
    this.albumId,
    this.album,
    this.artists = const [],
    this.albumArtists = const [],
    this.duration = Duration.zero,
    this.primaryTag,
    this.albumPrimaryTag,
    this.backdropTags = const [],
    this.year,
    this.index,
    this.disc,
    this.childCount,
    this.favorite = false,
    this.playCount = 0,
    this.overview,
    this.dateCreated,
    this.playlistItemId,
    this.cloud = false,
    this.recordType,
    this.streamUrl,
    this.normalizationGain,
  });

  factory Item.fromJson(Map<String, dynamic> j) {
    List<NameId> names(String key) => ((j[key] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(NameId.fromJson)
        .toList();
    final tags = (j['ImageTags'] as Map?) ?? const {};
    final user = (j['UserData'] as Map?) ?? const {};
    return Item(
      id: j['Id'] as String,
      // Playlists saved by the app/panel come with "Deezer · " in the name: the app does not show the origin.
      name: (j['Name'] as String? ?? '').replaceFirst(
        RegExp(r'^Deezer · '),
        '',
      ),
      kind: _kindOf(j['Type'] as String?),
      albumId: j['AlbumId'] as String?,
      album: j['Album'] as String?,
      artists: names('ArtistItems'),
      albumArtists: names('AlbumArtists'),
      duration: ticksToDuration(j['RunTimeTicks'] as num?),
      primaryTag: tags['Primary'] as String?,
      albumPrimaryTag: j['AlbumPrimaryImageTag'] as String?,
      backdropTags: ((j['BackdropImageTags'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      year: j['ProductionYear'] as int?,
      index: j['IndexNumber'] as int?,
      disc: j['ParentIndexNumber'] as int?,
      childCount: (j['ChildCount'] ?? j['SongCount']) as int?,
      favorite: user['IsFavorite'] as bool? ?? false,
      playCount: user['PlayCount'] as int? ?? 0,
      overview: j['Overview'] as String?,
      dateCreated: DateTime.tryParse(j['DateCreated'] as String? ?? ''),
      playlistItemId: j['PlaylistItemId'] as String?,
      normalizationGain: (j['NormalizationGain'] as num?)?.toDouble(),
    );
  }

  Item copyWith({bool? favorite}) => Item(
    id: id,
    name: name,
    kind: kind,
    albumId: albumId,
    album: album,
    artists: artists,
    albumArtists: albumArtists,
    duration: duration,
    primaryTag: primaryTag,
    albumPrimaryTag: albumPrimaryTag,
    backdropTags: backdropTags,
    year: year,
    index: index,
    disc: disc,
    childCount: childCount,
    favorite: favorite ?? this.favorite,
    playCount: playCount,
    overview: overview,
    dateCreated: dateCreated,
    playlistItemId: playlistItemId,
    cloud: cloud,
    recordType: recordType,
    streamUrl: streamUrl,
    normalizationGain: normalizationGain,
  );

  /// Panel catalog item (`/api/player/*`). Prefixed ids: dzt track, dza album, dzr artist,
  /// dzp playlist; what is already in the library comes with `jellyfin_id` and uses that id (plays from Jellyfin).
  factory Item.fromCatalog(Map<String, dynamic> j) {
    final kind = switch (j['kind']) {
      'track' => ItemKind.track,
      'album' => ItemKind.album,
      'artist' => ItemKind.artist,
      'playlist' => ItemKind.playlist,
      _ => ItemKind.other,
    };
    final jf = j['jellyfin_id'] as String?;
    final own = '${catalogPrefix(kind)}${j['deezer_id']}';
    final cover = j['cover'] as String?;
    final artistId = j['artist_id'] == null ? '' : 'dzr${j['artist_id']}';
    final albumId = j['album_id'] == null ? null : 'dza${j['album_id']}';
    if (cover != null) {
      catalogCovers[own] = cover;
      if (albumId != null) catalogCovers.putIfAbsent(albumId, () => cover);
    }
    final artist = (j['artist'] as String?) ?? '';
    final artists = artist.isEmpty ? <NameId>[] : [NameId(artistId, artist)];
    final isTrack = kind == ItemKind.track;
    return Item(
      id: jf ?? own,
      name: (j['title'] as String?) ?? '',
      kind: kind,
      albumId: albumId,
      album: j['album'] as String?,
      artists: isTrack ? artists : const [],
      albumArtists: artists,
      duration: Duration(seconds: (j['duration'] as num?)?.toInt() ?? 0),
      // Cover: a track uses its album's (registered in catalogCovers); everything else uses its own.
      primaryTag: isTrack || (jf != null && kind != ItemKind.album)
          ? null
          : 'dz',
      albumPrimaryTag: isTrack ? 'dz' : null,
      year: int.tryParse('${j['year'] ?? ''}'),
      childCount: (j['tracks'] as num?)?.toInt(),
      overview: '${j['owner'] ?? ''}'.toLowerCase().startsWith('deezer')
          ? null
          : j['owner'] as String?,
      cloud: jf == null,
      recordType: j['record_type'] as String?,
    );
  }

  /// Short version to store the queue on the device (close and reopen the app at the same place).
  Map<String, dynamic> toStore() => {
    'id': id,
    'n': name,
    'k': kind.index,
    'al': ?albumId,
    'a': ?album,
    'ar': [
      for (final x in artists) [x.id, x.name],
    ],
    'aa': [
      for (final x in albumArtists) [x.id, x.name],
    ],
    's': duration.inSeconds,
    'pt': ?primaryTag,
    'apt': ?albumPrimaryTag,
    if (favorite) 'f': true,
    if (cloud) 'c': true,
    'u': ?streamUrl,
    'g': ?normalizationGain,
    'cv': ?(catalogCovers[id] ?? catalogCovers[albumId]),
  };

  factory Item.fromStore(Map<String, dynamic> j) {
    List<NameId> names(Object? l) => [
      for (final x in (l as List?) ?? const [])
        if (x is List && x.length == 2) NameId('${x[0]}', '${x[1]}'),
    ];
    final it = Item(
      id: j['id'] as String,
      name: j['n'] as String? ?? '',
      kind: ItemKind.values[(j['k'] as int? ?? 0).clamp(0, 4)],
      albumId: j['al'] as String?,
      album: j['a'] as String?,
      artists: names(j['ar']),
      albumArtists: names(j['aa']),
      duration: Duration(seconds: j['s'] as int? ?? 0),
      primaryTag: j['pt'] as String?,
      albumPrimaryTag: j['apt'] as String?,
      favorite: j['f'] == true,
      cloud: j['c'] == true,
      streamUrl: j['u'] as String?,
      normalizationGain: (j['g'] as num?)?.toDouble(),
    );
    final cover = j['cv'] as String?;
    if (cover != null) {
      if (isCatalogId(it.id) || it.isPodcast) {
        catalogCovers.putIfAbsent(it.id, () => cover);
      }
      if (isCatalogId(it.albumId)) {
        catalogCovers.putIfAbsent(it.albumId!, () => cover);
      }
    }
    return it;
  }

  /// Catalog track/album/artist/playlist (not in the library): id starts with "dz".
  bool get isCatalog => isCatalogId(id);

  /// Deezer number of a catalog id ("dzt123" -> 123).
  int? get deezerId => catalogNumber(id);

  /// "Artist 1, Artist 2" for tracks; the album artist for albums.
  String get artistLine {
    final list = artists.isNotEmpty ? artists : albumArtists;
    return list.map((a) => a.name).join(', ');
  }

  NameId? get mainArtist => albumArtists.isNotEmpty
      ? albumArtists.first
      : (artists.isNotEmpty ? artists.first : null);

  /// Id of the item that holds the cover: itself, or the track's album.
  String? get imageItemId {
    if (primaryTag != null) return id;
    if (albumId != null && albumPrimaryTag != null) return albumId;
    if (kind != ItemKind.track) return id;
    return albumId;
  }

  String get typeLabel => switch (kind) {
    ItemKind.track => appL10n.commonSong,
    ItemKind.album => appL10n.commonAlbum,
    ItemKind.artist => appL10n.commonArtist,
    ItemKind.playlist => appL10n.commonPlaylist,
    ItemKind.other => '',
  };
}

/// Catalog covers by app id (Jellyfin does not have these images).
final Map<String, String> catalogCovers = {};

String catalogPrefix(ItemKind k) => switch (k) {
  ItemKind.track => 'dzt',
  ItemKind.album => 'dza',
  ItemKind.artist => 'dzr',
  ItemKind.playlist => 'dzp',
  ItemKind.other => 'dzx',
};

bool isCatalogId(String? id) => id != null && id.startsWith('dz');

int? catalogNumber(String? id) =>
    isCatalogId(id) ? int.tryParse(id!.substring(3)) : null;

/// Deezer cover URL at the closest size (catalog ones come at 1000x1000).
String? catalogCover(String? id, int size) {
  final url = catalogCovers[id];
  if (url == null) return null;
  final px = size <= 120
      ? 120
      : (size <= 250 ? 250 : (size <= 500 ? 500 : 1000));
  return url.replaceFirst(RegExp(r'/\d+x\d+-'), '/${px}x$px-');
}

class LyricLine {
  final Duration? start;
  final String text;
  const LyricLine(this.start, this.text);
}

class Lyrics {
  final List<LyricLine> lines;
  const Lyrics(this.lines);

  bool get synced => lines.isNotEmpty && lines.every((l) => l.start != null);
  bool get isEmpty => lines.isEmpty;

  factory Lyrics.fromJson(Map<String, dynamic> j) {
    final raw = (j['Lyrics'] as List?) ?? const [];
    return Lyrics(
      raw.whereType<Map<String, dynamic>>().map((l) {
        final start = l['Start'] as num?;
        return LyricLine(
          start == null ? null : ticksToDuration(start),
          (l['Text'] as String? ?? '').trim(),
        );
      }).toList(),
    );
  }

  /// Index of the line playing at [pos] (-1 before the first).
  int indexAt(Duration pos) {
    if (!synced) return -1;
    var lo = 0, hi = lines.length - 1, ans = -1;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      if (lines[mid].start! <= pos) {
        ans = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return ans;
  }
}
