import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/downloads.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/page_header.dart';
import '../../ui/widgets/track_table.dart';
import '../../ui/widgets/disk_image.dart';
import '../../state/library.dart';

// Catalog pages (Deezer via the panel): album, playlist and artist not yet in the library.
// What is already in the library comes with the Jellyfin id and plays from there; the rest has a cloud
// and plays via the panel.

final catalogAlbumProvider = FutureProvider.autoDispose
    .family<CatalogList, int>(
      (ref, id) => ref.watch(catalogProvider).album(id),
    );

final catalogPlaylistProvider = FutureProvider.autoDispose
    .family<CatalogList, int>(
      (ref, id) => ref.watch(catalogProvider).playlist(id),
    );

final catalogArtistProvider = FutureProvider.autoDispose
    .family<CatalogArtist, int>(
      (ref, id) => ref.watch(catalogProvider).artist(id: id),
    );

/// Deezer popular tracks for a library artist (by name).
final catalogArtistByNameProvider = FutureProvider.autoDispose
    .family<CatalogArtist?, String>((ref, name) async {
      try {
        return await ref.watch(catalogProvider).artist(name: name);
      } catch (_) {
        return null; // no panel: the artist page uses only the library
      }
    });

/// "Download" button of the catalog pages.
class DownloadButton extends ConsumerWidget {
  final String kind;
  final Item item;
  final String? label;
  const DownloadButton({
    super.key,
    required this.kind,
    required this.item,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: Pm.text,
      side: BorderSide(color: Pm.muted),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    icon: const Icon(Icons.download_outlined, size: 18),
    label: Text(
      label ?? context.l10n.catalogDownload,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    onPressed: () async {
      final msg = await ref
          .read(downloadsProvider.notifier)
          .request(kind, item);
      if (context.mounted) toast(context, msg);
    },
  );
}

/// Ready-made playlist -> Your Library: creates it with what is already there and downloads the rest
/// (the playlist completes itself).
class _SavePlaylistButton extends ConsumerStatefulWidget {
  final int deezerId;
  final Item head;
  const _SavePlaylistButton(this.deezerId, this.head);
  @override
  ConsumerState<_SavePlaylistButton> createState() =>
      _SavePlaylistButtonState();
}

class _SavePlaylistButtonState extends ConsumerState<_SavePlaylistButton> {
  bool _busy = false, _done = false;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: Pm.text,
      side: BorderSide(color: Pm.muted),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    icon: _busy
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(
            _done ? Icons.check_circle : Icons.add_circle_outline,
            size: 18,
            color: _done ? Pm.accent : null,
          ),
    label: Text(
      _done
          ? context.l10n.catalogInYourLibrary
          : context.l10n.catalogAddToLibrary,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    onPressed: _busy || _done
        ? null
        : () async {
            setState(() => _busy = true);
            try {
              final msg = await ref
                  .read(catalogProvider)
                  .savePlaylist(
                    widget.deezerId,
                    cover: catalogCovers[widget.head.id],
                  );
              ref.invalidate(libraryProvider);
              ref.read(downloadsProvider.notifier).refreshSoon();
              if (mounted) setState(() => _done = true);
              if (context.mounted) toast(context, msg);
            } catch (e) {
              if (context.mounted) toast(context, '$e');
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
  );
}

/// Album or playlist from the catalog.
class CatalogListPage extends ConsumerWidget {
  final String id; // dza123 or dzp123
  const CatalogListPage(this.id, {super.key});

  bool get _isAlbum => id.startsWith('dza');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final n = catalogNumber(id) ?? 0;
    final provider = _isAlbum
        ? catalogAlbumProvider(n)
        : catalogPlaylistProvider(n);
    final data = ref.watch(provider);
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => ErrorBox(e, onRetry: () => ref.invalidate(provider)),
      data: (d) {
        final a = d.head;
        final route = '/${_isAlbum ? 'album' : 'playlist'}/$id';
        final total = d.tracks.fold(Duration.zero, (s, t) => s + t.duration);
        final q = ref.watch(playerProvider);
        final isCtx = q.contextRoute == route;
        final have = d.tracks.where((t) => !t.cloud).length;
        final player = ref.read(playerProvider.notifier);
        return GradientPage(
          colorFromUrl: catalogCover(a.isCatalog ? a.id : id, 64),
          children: [
            BigHeader(
              cover: Cover(a, size: 232),
              type: _isAlbum ? l.commonAlbum : l.commonPlaylist,
              title: a.name,
              meta: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (a.mainArtist != null)
                    TextLink(
                      a.mainArtist!.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      onTap: () => context.go('/artist/${a.mainArtist!.id}'),
                    )
                  else if ((a.overview ?? '').isNotEmpty)
                    Text(
                      a.overview!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  if (a.year != null) Text(' • ${a.year}'),
                  Text(
                    ' • ${l.commonSongCount(d.tracks.length)}, ${formatTotal(total)}',
                    style: TextStyle(color: Pm.subdued),
                  ),
                  Text(
                    ' • ${have == d.tracks.length ? l.catalogAllInLibrary : l.catalogNInLibrary(have)}',
                    style: TextStyle(color: Pm.subdued),
                  ),
                ],
              ),
            ),
            ActionBar(
              children: [
                GreenPlayButton(
                  playing: isCtx && q.playing,
                  onPressed: () => isCtx
                      ? player.togglePlay()
                      : player.playList(
                          d.tracks,
                          contextName: a.name,
                          contextRoute: route,
                        ),
                ),
                const SizedBox(width: 16),
                IconBtn(
                  Icons.shuffle,
                  tooltip: l.commonShufflePlay,
                  size: 32,
                  onPressed: () => player.shufflePlay(
                    d.tracks,
                    contextName: a.name,
                    contextRoute: route,
                  ),
                ),
                const SizedBox(width: 8),
                if (_isAlbum && have < d.tracks.length)
                  DownloadButton(
                    kind: 'album',
                    item: a,
                    label: l.catalogDownloadAlbum,
                  ),
                if (!_isAlbum) _SavePlaylistButton(n, a),
              ],
            ),
            PageBody(
              child: TrackTable(
                tracks: d.tracks,
                contextName: a.name,
                contextRoute: route,
                showAlbum: !_isAlbum,
                showCover: !_isAlbum,
                useTrackNumbers: false,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Artist not in the library: Deezer's popular tracks, discography and related artists.
class CatalogArtistPage extends ConsumerStatefulWidget {
  final String id; // dzr123
  const CatalogArtistPage(this.id, {super.key});
  @override
  ConsumerState<CatalogArtistPage> createState() => _CatalogArtistPageState();
}

class _CatalogArtistPageState extends ConsumerState<CatalogArtistPage> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = catalogArtistProvider(catalogNumber(widget.id) ?? 0);
    final data = ref.watch(provider);
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => ErrorBox(e, onRetry: () => ref.invalidate(provider)),
      data: (d) {
        final a = d.artist;
        if (a == null) {
          return Center(child: Text(l.catalogArtistNotFound));
        }
        // Already in the library: go to the real page.
        if (!a.isCatalog) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.mounted ? context.go('/artist/${a.id}') : null,
          );
          return const LoadingBox();
        }
        final route = '/artist/${widget.id}';
        final q = ref.watch(playerProvider);
        final isCtx = q.contextRoute == route;
        final player = ref.read(playerProvider.notifier);
        final hero = catalogCover(a.id, 1000);
        final albums = d.albums.where((x) => (x.childCount ?? 99) > 3).toList();
        final singles = d.albums
            .where((x) => (x.childCount ?? 99) <= 3)
            .toList();
        return Container(
          color: Pm.base,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: isCompact(context) ? 300 : 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hero != null)
                      Image(
                        image: DiskImage(hero),
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.4),
                        errorBuilder: (_, _, _) =>
                            Container(color: Pm.highlight),
                      ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x99000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: isCompact(context) ? 16 : 24,
                      right: 24,
                      bottom: isCompact(context) ? 16 : 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isCompact(context) ? 40 : 88,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const CloudBadge(size: 16),
                              Text(
                                l.catalogFromCatalog,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2A2A2A), Pm.base],
                  ),
                ),
                child: ActionBar(
                  children: [
                    GreenPlayButton(
                      playing: isCtx && q.playing,
                      onPressed: () => isCtx
                          ? player.togglePlay()
                          : player.playList(
                              d.top,
                              contextName: a.name,
                              contextRoute: route,
                            ),
                    ),
                    const SizedBox(width: 16),
                    DownloadButton(
                      kind: 'artist',
                      item: a,
                      label: isCompact(context)
                          ? l.catalogDownloadAll
                          : l.catalogDownloadDiscography,
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (_) {
                        ref.watch(libraryProvider);
                        final following = followsCatalogArtist(ref, a);
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Pm.text,
                            side: BorderSide(color: Pm.muted),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => toggleFavorite(
                            context,
                            ref,
                            a.copyWith(favorite: following),
                          ),
                          child: Text(
                            following ? l.commonFollowing : l.commonFollow,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              PageBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (d.top.isNotEmpty) ...[
                      SectionHeader(l.catalogPopular),
                      TrackTable(
                        tracks: d.top,
                        contextName: a.name,
                        contextRoute: route,
                        showAlbum: false,
                        showHeader: false,
                        limit: _showMore ? 10 : 5,
                      ),
                      if (d.top.length > 5)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 24),
                          child: TextLink(
                            _showMore ? l.catalogShowLess : l.catalogShowMore,
                            style: TextStyle(
                              color: Pm.subdued,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            onTap: () => setState(() => _showMore = !_showMore),
                          ),
                        ),
                    ],
                    if (albums.isNotEmpty)
                      Shelf(title: l.commonAlbums, items: albums),
                    if (singles.isNotEmpty)
                      Shelf(title: l.catalogSinglesEps, items: singles),
                    if (d.related.isNotEmpty)
                      Shelf(title: l.catalogFansAlsoLike, items: d.related),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
