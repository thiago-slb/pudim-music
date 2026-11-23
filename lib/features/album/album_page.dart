import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/library.dart';
import '../../state/offline.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/offline_button.dart';
import '../../ui/widgets/page_header.dart';
import '../../ui/widgets/track_table.dart';
import '../playlist/playlist_page.dart';
import '../../state/quality.dart';

class _AlbumData {
  final Item album;
  final List<Item> tracks;
  final List<Item> more;
  _AlbumData(this.album, this.tracks, this.more);
}

final _albumProvider = FutureProvider.autoDispose.family<_AlbumData, String>((
  ref,
  id,
) async {
  final api = ref.watch(apiProvider);
  final r = await Future.wait([api.item(id), api.albumTracks(id)]);
  final album = r[0] as Item;
  final artist = album.mainArtist;
  final more = artist == null || artist.id.isEmpty
      ? <Item>[]
      : (await api.artistAlbums(artist.id).catchError((_) => <Item>[]))
            .where((a) => a.id != id)
            .toList();
  return _AlbumData(album, r[1] as List<Item>, more);
});

class AlbumPage extends ConsumerWidget {
  final String id;
  const AlbumPage(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_albumProvider(id));
    final off = ref.watch(offlineProvider);
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => off.saved(id)
          ? TracksPage(
              title: off.collections[id]!.name,
              type: 'Álbum • baixado no aparelho',
              cover: Cover(off.collections[id]!.head, size: 232),
              color: const Color(0xFF1E3A2A),
              owner: off.collections[id]!.head?.artistLine ?? '',
              tracks: off.tracksOf(id),
              route: '/album/$id',
              offlineId: id,
            )
          : ErrorBox(e, onRetry: () => ref.invalidate(_albumProvider(id))),
      data: (d) {
        Future.microtask(() => ref.read(recentOpenProvider.notifier).touch(id));
        final api = ref.watch(apiProvider);
        final a = d.album;
        final total = d.tracks.fold(Duration.zero, (s, t) => s + t.duration);
        final route = '/album/$id';
        final q = ref.watch(playerProvider);
        final isCtx = q.contextRoute == route;
        final multiDisc = d.tracks.map((t) => t.disc ?? 1).toSet().length > 1;
        final tag = qualityTag(
          ref
              .watch(qualityProvider(a.mainArtist?.name ?? ''))
              .value
              ?.of(a.name),
        );
        return GradientPage(
          colorFromUrl: api.imageUrl(a.id, size: 64),
          children: [
            BigHeader(
              cover: Cover(a, size: 232),
              type: 'Álbum',
              title: a.name,
              meta: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (a.mainArtist != null) ...[
                    Cover(
                      Item(
                        id: a.mainArtist!.id,
                        name: '',
                        kind: ItemKind.artist,
                      ),
                      size: 24,
                      round: true,
                    ),
                    const SizedBox(width: 6),
                    TextLink(
                      a.mainArtist!.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      onTap: () => context.go('/artist/${a.mainArtist!.id}'),
                    ),
                  ],
                  if (a.year != null) Text(' • ${a.year}'),
                  Text(
                    ' • ${d.tracks.length} músicas, ${formatTotal(total)}',
                    style: const TextStyle(color: Pm.subdued),
                  ),
                  if (tag != null) ...[
                    const SizedBox(width: 8),
                    QualityChip(tag),
                  ],
                ],
              ),
            ),
            ActionBar(
              children: [
                GreenPlayButton(
                  playing: isCtx && q.playing,
                  onPressed: () => isCtx
                      ? ref.read(playerProvider.notifier).togglePlay()
                      : ref
                            .read(playerProvider.notifier)
                            .playList(
                              d.tracks,
                              contextName: a.name,
                              contextRoute: route,
                            ),
                ),
                const SizedBox(width: 16),
                IconBtn(
                  Icons.shuffle,
                  tooltip: 'Tocar em ordem aleatória',
                  size: 32,
                  onPressed: () => ref
                      .read(playerProvider.notifier)
                      .shufflePlay(
                        d.tracks,
                        contextName: a.name,
                        contextRoute: route,
                      ),
                ),
                OfflineButton(id: id, name: a.name, head: a, tracks: d.tracks),
                IconBtn(
                  a.favorite ? Icons.check_circle : Icons.add_circle_outline,
                  tooltip: a.favorite
                      ? 'Remover da Sua Biblioteca'
                      : 'Salvar na Sua Biblioteca',
                  size: 32,
                  active: a.favorite,
                  onPressed: () async {
                    await toggleFavorite(context, ref, a);
                    ref.invalidate(_albumProvider(id));
                  },
                ),
                Builder(
                  builder: (bctx) => IconBtn(
                    Icons.more_horiz,
                    tooltip: 'Mais opções para ${a.name}',
                    size: 32,
                    onPressed: () {
                      final box = bctx.findRenderObject() as RenderBox;
                      showItemMenu(
                        context,
                        ref,
                        a,
                        box.localToGlobal(box.size.bottomLeft(Offset.zero)),
                      );
                    },
                  ),
                ),
              ],
            ),
            PageBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!multiDisc)
                    TrackTable(
                      tracks: d.tracks,
                      contextName: a.name,
                      contextRoute: route,
                      showAlbum: false,
                      showCover: false,
                      useTrackNumbers: true,
                    )
                  else
                    for (final disc
                        in d.tracks.map((t) => t.disc ?? 1).toSet()) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.album_outlined,
                              size: 18,
                              color: Pm.subdued,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Disco $disc',
                              style: const TextStyle(
                                color: Pm.subdued,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TrackTable(
                        tracks: d.tracks
                            .where((t) => (t.disc ?? 1) == disc)
                            .toList(),
                        contextName: a.name,
                        contextRoute: route,
                        showAlbum: false,
                        showCover: false,
                        useTrackNumbers: true,
                        showHeader: disc == d.tracks.first.disc,
                      ),
                    ],
                  const SizedBox(height: 32),
                  if (d.more.isNotEmpty)
                    Shelf(
                      title: 'Mais de ${a.mainArtist?.name ?? ''}',
                      items: d.more,
                      onShowAll: () =>
                          context.go('/artist/${a.mainArtist!.id}'),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
