import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../state/session.dart';

/// Lyrics of a track: what Jellyfin reads next to the file (.lrc/.txt), or, when the server has
/// none, the copy this device downloaded with the "Find lyrics" button.
final lyricsProvider = FutureProvider.family<Lyrics, String>((ref, id) async {
  ref.keepAlive();
  Lyrics server;
  try {
    server = await ref.watch(apiProvider).lyrics(id);
  } catch (_) {
    server = const Lyrics([]);
  }
  if (!server.isEmpty) return server;
  final saved = ref.read(prefsProvider).getString(_savedKey(id));
  return saved == null ? server : parseLrc(saved);
});

String _savedKey(String trackId) => 'lyrics.$trackId';

/// Turns an .lrc (or plain text) into lines; "[mm:ss.xx]" stamps make it synced, tags such as
/// "[ar:...]" are skipped, and a line with several stamps repeats at each of them.
Lyrics parseLrc(String text) {
  final stamp = RegExp(r'\[(\d+):(\d{1,2})(?:[.:](\d{1,3}))?\]');
  final tag = RegExp(r'^\[[a-zA-Z]+:.*\]$');
  final timed = <LyricLine>[];
  final plain = <LyricLine>[];
  for (final raw in text.split(RegExp(r'\r?\n'))) {
    final line = raw.trim();
    final stamps = stamp.allMatches(line).toList();
    if (stamps.isEmpty) {
      if (line.isNotEmpty && !tag.hasMatch(line)) {
        plain.add(LyricLine(null, line));
      }
      continue;
    }
    final words = line.substring(stamps.last.end).trim();
    for (final m in stamps) {
      final frac = m.group(3) ?? '0';
      final ms = int.parse(frac.padRight(3, '0').substring(0, 3));
      timed.add(
        LyricLine(
          Duration(
            minutes: int.parse(m.group(1)!),
            seconds: int.parse(m.group(2)!),
            milliseconds: ms,
          ),
          words,
        ),
      );
    }
  }
  if (timed.isEmpty) return Lyrics(plain);
  timed.sort((a, b) => a.start!.compareTo(b.start!));
  return Lyrics(timed);
}

/// Public lyrics library used when the server finds nothing (free, no account).
class LyricsLibrary {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://lrclib.net/api',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'User-Agent': 'PudimMusic'},
    ),
  );

  @visibleForTesting
  static set adapter(HttpClientAdapter a) => _dio.httpClientAdapter = a;

  /// The .lrc text (synced when there is one, plain otherwise) of [track], or null.
  static Future<String?> find(Item track) async {
    final artist = track.mainArtist?.name ?? '';
    final secs = track.duration.inSeconds;
    String? pick(Map<String, dynamic> j) {
      if (j['instrumental'] == true) return null;
      final s = j['syncedLyrics'] as String?;
      if (s != null && s.trim().isNotEmpty) return s;
      final p = j['plainLyrics'] as String?;
      return p != null && p.trim().isNotEmpty ? p : null;
    }

    try {
      final r = await _dio.get(
        '/get',
        queryParameters: {
          'track_name': track.name,
          'artist_name': artist,
          if (track.album != null) 'album_name': track.album,
          if (secs > 0) 'duration': secs,
        },
      );
      final hit = pick(r.data as Map<String, dynamic>);
      if (hit != null) return hit;
    } catch (_) {
      // Not found with these exact details: falls back to a search below.
    }
    try {
      final r = await _dio.get(
        '/search',
        queryParameters: {'track_name': track.name, 'artist_name': artist},
      );
      final list = (r.data as List).whereType<Map<String, dynamic>>().toList();
      // Same recording (length within 10 s), synced before plain, closest length first.
      int gap(Map<String, dynamic> j) =>
          secs == 0 ? 0 : (((j['duration'] as num?) ?? 0) - secs).abs().round();
      bool synced(Map<String, dynamic> j) =>
          (j['syncedLyrics'] as String?)?.isNotEmpty == true;
      list.removeWhere((j) => gap(j) > 10);
      list.sort((a, b) {
        final sa = synced(a) ? 0 : 1, sb = synced(b) ? 0 : 1;
        return sa != sb ? sa - sb : gap(a) - gap(b);
      });
      for (final j in list) {
        final hit = pick(j);
        if (hit != null) return hit;
      }
    } catch (_) {}
    return null;
  }
}

/// Looks for the lyrics of [track]: first through the server's own providers (saved next to the
/// file, so every device gets them), then in the public library; those are sent to the server
/// when it allows and always kept on this device. True when lyrics were found.
Future<bool> findLyrics(WidgetRef ref, Item track) async {
  final api = ref.read(apiProvider);
  if (!track.isCatalog && await api.downloadServerLyrics(track.id) != null) {
    ref.invalidate(lyricsProvider(track.id));
    return true;
  }
  final lrc = await LyricsLibrary.find(track);
  if (lrc == null || parseLrc(lrc).isEmpty) return false;
  await ref.read(prefsProvider).setString(_savedKey(track.id), lrc);
  if (!track.isCatalog) await api.uploadLyrics(track.id, lrc);
  ref.invalidate(lyricsProvider(track.id));
  return true;
}
