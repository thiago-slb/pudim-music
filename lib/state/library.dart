import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/models.dart';
import 'session.dart';
import '../api/catalog.dart';

/// Itens da "Sua Biblioteca": playlists, álbuns salvos e artistas seguidos.
class LibraryData {
  final List<Item> playlists;
  final List<Item> albums;
  final List<Item> artists;
  const LibraryData(this.playlists, this.albums, this.artists);
}

final libraryProvider = FutureProvider<LibraryData>((ref) async {
  final api = ref.watch(apiProvider);
  // seguidos sem nenhum álbum na biblioteca (vêm do painel; sem painel, a lista fica só com os do Jellyfin)
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

/// Se este artista do catálogo (fora da biblioteca) está sendo seguido.
bool followsCatalogArtist(WidgetRef ref, Item it) =>
    ref.read(libraryProvider).value?.artists.any((a) => a.id == it.id) ?? false;

final likedTracksProvider = FutureProvider<List<Item>>(
  (ref) => ref.watch(apiProvider).favoriteTracks(),
);

/// Ordem em que a Sua Biblioteca foi aberta/tocada por último (só local).
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
