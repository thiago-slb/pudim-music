import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/models.dart';
import '../api/response_cache.dart';
import '../ui/widgets/disk_image.dart';
import 'library.dart';
import 'session.dart';

/// With internet, stores in the background the pages of Your Library (playlists, albums and
/// artists) and the covers, so everything opens without internet even what was never opened.
/// Each item is refreshed at most every 12 h.
final prefetchProvider = Provider<void>((ref) {
  ref.listen(libraryProvider, (_, next) {
    final d = next.value;
    if (d != null) unawaited(_run(ref, d));
  }, fireImmediately: true);
});

bool _running = false;

Future<void> _run(Ref ref, LibraryData d) async {
  final cache = ResponseCache.instance;
  if (_running || cache == null) return;
  _running = true;
  try {
    await Future<void>.delayed(const Duration(seconds: 10));
    final api = ref.read(apiProvider);
    final stamps = File(
      '${cache.dir.path}${Platform.pathSeparator}prefetch.json',
    );
    final done = <String, int>{};
    try {
      (jsonDecode(await stamps.readAsString()) as Map).forEach(
        (k, v) => done['$k'] = v as int,
      );
    } catch (_) {}
    final now = DateTime.now().millisecondsSinceEpoch;
    const fresh = 12 * 3600 * 1000;

    Future<void> cover(Item it) async {
      for (final size in const [96, 464]) {
        final url = api.imageUrl(it.imageItemId, size: size);
        if (url != null) await DiskImage.prefetch(url);
      }
    }

    // Liked songs and the covers of their tracks.
    final liked = await ref
        .read(likedTracksProvider.future)
        .catchError((_) => <Item>[]);
    for (final t in liked.take(500)) {
      final url = api.imageUrl(t.imageItemId, size: 96);
      if (url != null) await DiskImage.prefetch(url);
    }

    final items = [...d.playlists, ...d.albums, ...d.artists];
    var n = 0;
    for (final it in items) {
      if (cache.offline.value) break;
      if (now - (done[it.id] ?? 0) < fresh) continue;
      try {
        switch (it.kind) {
          case ItemKind.playlist:
            await api.item(it.id);
            final tracks = await api.playlistTracks(it.id);
            for (final t in tracks.take(200)) {
              final url = api.imageUrl(t.imageItemId, size: 96);
              if (url != null) await DiskImage.prefetch(url);
            }
          case ItemKind.album:
            final a = await api.item(it.id);
            await api.albumTracks(it.id);
            final artist = a.mainArtist;
            if (artist != null && artist.id.isNotEmpty) {
              await api.artistAlbums(artist.id);
            }
          case ItemKind.artist:
            await api.item(it.id);
            await api.artistTopTracks(it.id, limit: 10);
            final albums = await api.artistAlbums(it.id);
            for (final a in albums) {
              await cover(a);
            }
          default:
        }
        await cover(it);
        done[it.id] = now;
        if (++n % 10 == 0) await stamps.writeAsString(jsonEncode(done));
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    await stamps.writeAsString(jsonEncode(done));
  } catch (_) {
  } finally {
    _running = false;
  }
}
