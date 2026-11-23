import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // Sem internet, o que não estiver guardado vem vazio em vez de derrubar a página.
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
        // Populares como no Spotify: top do Deezer (o que tem toca da biblioteca, o resto pelo painel).
        final dz = ref.watch(catalogArtistByNameProvider(a.name)).value;
        // Qualidade das pastas (FLAC, som fraco) vinda do painel.
        final quality = ref.watch(qualityProvider(a.name)).value;
        final top = (dz?.top.isNotEmpty ?? false) ? dz!.top : d.top;
        // Discografia completa: o que está na biblioteca + o que falta (do catálogo, com nuvem para baixar).
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
              // Banner grande com o nome por cima.
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
                          Text(
                            '${d.albums.length} álbuns na biblioteca'
                            '${a.playCount > 0 ? ' • ${a.playCount} reproduções' : ''}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
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
                      onPressed: () =>
                          isCtx ? player.togglePlay() : _playAll(top, a, route),
                    ),
                    const SizedBox(width: 16),
                    IconBtn(
                      Icons.shuffle,
                      tooltip: 'Tocar em ordem aleatória',
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
                        side: const BorderSide(color: Pm.muted),
                        shape: const StadiumBorder(),
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
                        a.favorite ? 'Seguindo' : 'Seguir',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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
              ),
              PageBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (top.isNotEmpty) ...[
                      const SectionHeader('Populares'),
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
                            _showMore ? 'Mostrar menos' : 'Ver mais',
                            style: const TextStyle(
                              color: Pm.subdued,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            onTap: () => setState(() => _showMore = !_showMore),
                          ),
                        ),
                    ],
                    if (d.liked.isNotEmpty) ...[
                      const SectionHeader('Você curtiu'),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Cover(a, size: 72, round: true),
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Pm.green,
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
                                '${d.liked.length} músicas',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                onTap: () => player.playList(
                                  d.liked,
                                  contextName: 'Você curtiu: ${a.name}',
                                ),
                              ),
                              Text(
                                'De ${a.name}',
                                style: const TextStyle(color: Pm.subdued),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (d.albums.isNotEmpty || cloudAlbums.isNotEmpty) ...[
                      const SectionHeader('Discografia'),
                      ChipBar(
                        padding: const EdgeInsets.only(bottom: 8),
                        children: [
                          Chip2(
                            'Lançamentos populares',
                            selected: _disco == _Disco.popular,
                            onTap: () =>
                                setState(() => _disco = _Disco.popular),
                          ),
                          Chip2(
                            'Álbuns',
                            selected: _disco == _Disco.albums,
                            onTap: () => setState(() => _disco = _Disco.albums),
                          ),
                          Chip2(
                            'Singles e EPs',
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
                              'single' => 'Single',
                              'ep' => 'EP',
                              _ => 'Álbum',
                            }
                          else
                            qualityTag(quality?.of(x.name)) ?? x.artistLine,
                        ].join(' • '),
                      ),
                    ],
                    if (d.similar.isNotEmpty)
                      Shelf(title: 'Fãs também curtem', items: d.similar),
                    if (d.appearsOn.isNotEmpty)
                      Shelf(title: 'Aparece em', items: d.appearsOn),
                    if ((a.overview ?? '').isNotEmpty) ...[
                      const SectionHeader('Sobre'),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Text(
                          a.overview!.replaceAll(RegExp(r'<[^>]*>'), ''),
                          style: const TextStyle(
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
