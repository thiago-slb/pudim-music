import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/models.dart';
import 'session.dart';
import '../api/catalog.dart';

/// Items of "Your Library": playlists, saved albums and followed artists.
class LibraryData {
  final List<Item> playlists;
  final List<Item> albums;
  final List<Item> artists;
  const LibraryData(this.playlists, this.albums, this.artists);
}

final libraryProvider = FutureProvider<LibraryData>((ref) async {
  final api = ref.watch(apiProvider);
  // followed artists with no album in the library (they come from the panel; without a panel, the list only has the Jellyfin ones)
  final extra = ref
      .watch(catalogProvider)
      .followedArtists()
      .timeout(const Duration(seconds: 6))
      .catchError((_) => const <Item>[]);
  final r = await Future.wait([
    api.playlists(),
    api.favoriteAlbums(),
    api.favoriteArtists(),
  ]);
  final have = {for (final a in r[2]) a.name.toLowerCase()};
  return LibraryData(r[0], r[1], [
    ...r[2],
    ...(await extra).where((a) => !have.contains(a.name.toLowerCase())),
  ]);
});

/// Whether this catalog artist (outside the library) is being followed.
bool followsCatalogArtist(WidgetRef ref, Item it) =>
    ref.read(libraryProvider).value?.artists.any((a) => a.id == it.id) ?? false;

final likedTracksProvider = FutureProvider<List<Item>>(
  (ref) => ref.watch(apiProvider).favoriteTracks(),
);

/// Order in which Your Library was last opened/played (local only).
final recentOpenProvider = NotifierProvider<RecentOpen, List<String>>(
  RecentOpen.new,
);

class RecentOpen extends Notifier<List<String>> {
  @override
  List<String> build() =>
      ref.read(prefsProvider).getStringList('recentOpen') ?? const [];

  void touch(String id) {
    if (state.isNotEmpty && state.first == id) return;
    final list = [id, ...state.where((x) => x != id)].take(200).toList();
    state = list;
    ref.read(prefsProvider).setStringList('recentOpen', list);
  }
}
