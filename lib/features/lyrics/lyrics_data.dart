import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../state/session.dart';

/// Lyrics of a track (Jellyfin reads the .lrc/.txt next to the file).
final lyricsProvider = FutureProvider.family<Lyrics, String>((ref, id) async {
  ref.keepAlive();
  try {
    return await ref.watch(apiProvider).lyrics(id);
  } catch (_) {
    return const Lyrics([]);
  }
});
