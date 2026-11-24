import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/library.dart';
import '../catalog/catalog_pages.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/page_header.dart';
import '../../ui/widgets/track_table.dart';
import '../../ui/widgets/disk_image.dart';
import '../../state/quality.dart';

class _ArtistData {
  final Item artist;
  final List<Item> top;
  final List<Item> albums;
  final List<Item> appearsOn;
  final List<Item> similar;
  final List<Item> liked;
  _ArtistData(
    this.artist,
    this.top,
    this.albums,
    this.appearsOn,
    this.similar,
    this.liked,
  );
}

final _artistProvider = FutureProvider.autoDispose.family<_ArtistData, String>((
  ref,
  id,
) async {
  final api = ref.watch(apiProvider);
  final r = await Future.wait([
    api.item(id),
    // Offline, anything not stored comes back empty instead of crashing the page.
    api.artistTopTracks(id, limit: 10).catchError((_) => <Item>[]),
    api.artistAlbums(id),
    api.appearsOn(id).catchError((_) => <Item>[]),
    api.similar(id).catchError((_) => <Item>[]),
    api
        .items({
          'ArtistIds': id,
          'IncludeItemTypes': 'Audio',
          'Recursive': true,
          'Filters': 'IsFavorite',
        })
        .catchError((_) => <Item>[]),
  ]);
  final albums = r[2] as List<Item>;
  final albumIds = albums.map((a) => a.id).toSet();
  return _ArtistData(
    r[0] as Item,
    r[1] as List<Item>,
    albums,
    (r[3] as List<Item>).where((a) => !albumIds.contains(a.id)).toList(),
    (r[4] as List<Item>).where((a) => a.kind == ItemKind.artist).toList(),
    r[5] as List<Item>,
  );
});

enum _Disco { popular, albums, singles }

class ArtistPage extends ConsumerStatefulWidget {
  final String id;
  const ArtistPage(this.id, {super.key});
  @override
  ConsumerState<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends ConsumerState<ArtistPage> {
  bool _showMore = false;
  _Disco _disco = _Disco.popular;

  bool _isSingle(Item a) => (a.childCount ?? 99) <= 3;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(_artistProvider(widget.id));
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => ErrorBox(
        e,
        onRetry: () => ref.invalidate(_artistProvider(widget.id)),
      ),
      data: (d) {
        Future.microtask(
          () => ref.read(recentOpenProvider.notifier).touch(widget.id),
        );
        final api = ref.watch(apiProvider);
        final a = d.artist;
        final route = '/artist/${widget.id}';
        final q = ref.watch(playerProvider);
        final isCtx = q.contextRoute == route;
        final player = ref.read(playerProvider.notifier);
        final hero = a.backdropTags.isNotEmpty
            ? api.imageUrl(a.id, type: 'Backdrop', size: 1600)
            : api.imageUrl(a.id, size: 1200);
        // Popular tracks like Spotify: Deezer's top (what exists plays from the library, the rest via the panel).
        final dz = ref.watch(catalogArtistByNameProvider(a.name)).value;
        // Folder quality (FLAC, weak audio) coming from the panel.
        final quality = ref.watch(qualityProvider(a.name)).value;
        final top = (dz?.top.isNotEmpty ?? false) ? dz!.top : d.top;
        // Full discography: what is in the library + what is missing (from the catalog, with a cloud to download).
        final cloudAlbums = (dz?.albums ?? const <Item>[])
            .where((x) => x.cloud)
            .toList();
        bool cloudSingle(Item x) => x.recordType == null
            ? (x.childCount ?? 99) <= 3
            : x.recordType == 'single' || x.recordType == 'ep';
        int byYear(Item x, Item y) => (y.year ?? 0).compareTo(x.year ?? 0);
        final disco = switch (_disco) {
          _Disco.popular => [
            ...d.albums,
          ]..sort((x, y) => y.playCount.compareTo(x.playCount)),
          _Disco.albums => [
            ...d.albums.where((x) => !_isSingle(x)),
            ...cloudAlbums.where((x) => !cloudSingle(x)),
          ]..sort(byYear),
          _Disco.singles => [
            ...d.albums.where(_isSingle),
            ...cloudAlbums.where(cloudSingle),
          ]..sort(byYear),
        };
        return Container(
          color: Pm.base,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Large banner with the name on top.
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: switch (Pm.current.style) {
                            UiStyle.ruby => [Colors.transparent, Pm.base],
                            UiStyle.wave => [
                              Pm.accent.withValues(alpha: 0.15),
                              Color.lerp(Pm.accent, Pm.base, 0.55)!,
                            ],
                            UiStyle.glass => [
                              Colors.transparent,
                              Pm.accent.withValues(alpha: 0.35),
                              Pm.base,
                            ],
                            UiStyle.retro => [
                              Colors.transparent,
                              Pm.base.withValues(alpha: 0.9),
                            ],
                            UiStyle.night => [
                              Colors.transparent,
                              const Color(0x99000000),
                            ],
                          },
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
                          pageTitle(
                            a.name,
                            isCompact(context) ? 40 : 88,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.artistAlbumsInLibrary(
                                  d.albums.length,
                                ) +
                                (a.playCount > 0
                                    ? ' • ${context.l10n.artistPlays(a.playCount)}'
                                    : ''),
                            style: const TextStyle(fontSize: 15),
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
                    colors: [
                      Pm.current.style == UiStyle.night
                          ? const Color(0xFF2A2A2A)
                          : Pm.base,
                      Pm.base,
                    ],
                  ),
                ),
                child: ActionBar(
                  children: [
                    GreenPlayButton(
                      playing: isCtx && q.playing,
                      onPressed: () =>
                          isCtx ? player.togglePlay() : _playAll(top, a, route),
                    ),
                    const SizedBox(width: 16),
                    IconBtn(
                      Icons.shuffle,
                      tooltip: context.l10n.commonShufflePlay,
                      size: 32,
                      onPressed: () async {
                        final all = await api.artistAllTracks(widget.id);
                        player.shufflePlay(
                          all,
                          contextName: a.name,
                          contextRoute: route,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Pm.text,
                        side: BorderSide(color: Pm.muted),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        await toggleFavorite(context, ref, a);
                        ref.invalidate(_artistProvider(widget.id));
                      },
                      child: Text(
                        a.favorite
                            ? context.l10n.commonFollowing
                            : context.l10n.commonFollow,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Builder(
                      builder: (bctx) => IconBtn(
                        Icons.more_horiz,
                        tooltip: context.l10n.artistMoreOptions(a.name),
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
              ),
              PageBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (top.isNotEmpty) ...[
                      SectionHeader(context.l10n.artistPopular),
                      TrackTable(
                        tracks: top,
                        contextName: a.name,
                        contextRoute: route,
                        showAlbum: false,
                        showHeader: false,
                        limit: _showMore ? 10 : 5,
                      ),
                      if (top.length > 5)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 24),
                          child: TextLink(
                            _showMore
                                ? context.l10n.artistShowLess
                                : context.l10n.artistShowMore,
                            style: TextStyle(
                              color: Pm.subdued,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            onTap: () => setState(() => _showMore = !_showMore),
                          ),
                        ),
                    ],
                    if (d.liked.isNotEmpty) ...[
                      SectionHeader(context.l10n.artistYouLiked),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Cover(a, size: 72, round: true),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Pm.accent,
                                  child: Icon(
                                    Icons.favorite,
                                    size: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLink(
                                context.l10n.commonSongCount(d.liked.length),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                onTap: () => player.playList(
                                  d.liked,
                                  contextName:
                                      '${context.l10n.artistYouLiked}: ${a.name}',
                                ),
                              ),
                              Text(
                                context.l10n.artistFrom(a.name),
                                style: TextStyle(color: Pm.subdued),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (d.albums.isNotEmpty || cloudAlbums.isNotEmpty) ...[
                      SectionHeader(context.l10n.artistDiscography),
                      ChipBar(
                        padding: const EdgeInsets.only(bottom: 8),
                        children: [
                          Chip2(
                            context.l10n.artistPopularReleases,
                            selected: _disco == _Disco.popular,
                            onTap: () =>
                                setState(() => _disco = _Disco.popular),
                          ),
                          Chip2(
                            context.l10n.commonAlbums,
                            selected: _disco == _Disco.albums,
                            onTap: () => setState(() => _disco = _Disco.albums),
                          ),
                          Chip2(
                            context.l10n.artistSinglesEps,
                            selected: _disco == _Disco.singles,
                            onTap: () =>
                                setState(() => _disco = _Disco.singles),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Shelf(
                        title: '',
                        items: disco,
                        subtitleOf: (x) => [
                          if (x.year != null) '${x.year}',
                          if (x.cloud)
                            switch (x.recordType) {
                              'single' => context.l10n.commonSingle,
                              'ep' => 'EP',
                              _ => context.l10n.commonAlbum,
                            }
                          else
                            qualityTag(quality?.of(x.name)) ?? x.artistLine,
                        ].join(' • '),
                      ),
                    ],
                    if (d.similar.isNotEmpty)
                      Shelf(
                        title: context.l10n.artistFansAlsoLike,
                        items: d.similar,
                      ),
                    if (d.appearsOn.isNotEmpty)
                      Shelf(
                        title: context.l10n.artistAppearsOn,
                        items: d.appearsOn,
                      ),
                    if ((a.overview ?? '').isNotEmpty) ...[
                      SectionHeader(context.l10n.artistAbout),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Text(
                          a.overview!.replaceAll(RegExp(r'<[^>]*>'), ''),
                          style: TextStyle(
                            color: Pm.subdued,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _playAll(List<Item> top, Item a, String route) {
    ref
        .read(playerProvider.notifier)
        .playList(top, contextName: a.name, contextRoute: route);
  }
}
