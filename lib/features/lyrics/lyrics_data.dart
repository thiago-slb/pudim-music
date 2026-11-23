import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../state/session.dart';

/// Letra de uma faixa (o Jellyfin lê os .lrc/.txt ao lado do arquivo).
final lyricsProvider = FutureProvider.family<Lyrics, String>((ref, id) async {
  ref.keepAlive();
  try {
    return await ref.watch(apiProvider).lyrics(id);
  } catch (_) {
    return const Lyrics([]);
  }
});
