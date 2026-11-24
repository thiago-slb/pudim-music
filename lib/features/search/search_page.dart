import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';

import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/downloads.dart';
import '../../state/library.dart';
import '../../state/session.dart';
import '../../state/ui.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/track_table.dart';
import '../../ui/widgets/themed.dart';

class SearchResults {
  final List<Item> artists;
  final List<Item> tracks;
  final List<Item> albums;
  final List<Item> playlists;
  SearchResults(this.artists, this.tracks, this.albums, this.playlists);
  bool get isEmpty =>
      artists.isEmpty && tracks.isEmpty && albums.isEmpty && playlists.isEmpty;

  /// Library first; from the catalog only what isn't a duplicate (what already exists comes with
  /// the Jellyfin id).
  SearchResults merge(CatalogSearch c) {
    List<Item> join(List<Item> a, List<Item> b) {
      final seen = {for (final x in a) x.id};
      return [...a, ...b.where((x) => seen.add(x.id))];
    }

    return SearchResults(
      join(artists, c.artists),
      join(tracks, c.tracks),
      join(albums, c.albums),
      join(playlists, c.playlists),
    );
  }

  Item? get top {
    if (artists.isNotEmpty) return artists.first;
    if (tracks.isNotEmpty) return tracks.first;
    if (albums.isNotEmpty) return albums.first;
    if (playlists.isNotEmpty) return playlists.first;
    return null;
  }
}

final searchProvider = FutureProvider.autoDispose.family<SearchResults, String>(
  (ref, q) async {
    final api = ref.watch(apiProvider);
    final r = await Future.wait([
      api.searchArtists(q),
      api.search(q, 'Audio', limit: 30),
      api.search(q, 'MusicAlbum', limit: 20),
      api.search(q, 'Playlist', limit: 20),
    ]);
    return SearchResults(r[0], r[1], r[2], r[3]);
  },
);

enum _Tab { all, artists, tracks, albums, playlists }

class SearchPage extends ConsumerStatefulWidget {
  final String query;
  const SearchPage({super.key, required this.query});
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  _Tab _tab = _Tab.all;

  @override
  void didUpdateWidget(SearchPage old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query && widget.query.isNotEmpty) {
      Future.microtask(
        () => ref.read(recentSearchesProvider.notifier).add(widget.query),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.query.trim();
    final content = q.isEmpty ? const _Browse() : _results(q);
    return Container(
      color: Pm.base,
      child: isCompact(context)
          ? Column(
              children: [
                _MobileSearchField(query: widget.query),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }

  Widget _results(String q) {
    final res = ref.watch(searchProvider(q));
    final cat = ref.watch(catalogSearchProvider(q));
    return res.when(
      loading: () => const LoadingBox(),
      error: (e, _) =>
          ErrorBox(e, onRetry: () => ref.invalidate(searchProvider(q))),
      data: (lib) {
        final r = lib.merge(cat.value ?? CatalogSearch.empty);
        if (r.isEmpty && cat.isLoading) return const LoadingBox();
        if (r.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: context.l10n.searchNoResults(q),
            subtitle: context.l10n.searchNoResultsHint,
            action: !cat.hasError
                ? null
                : Text(
                    context.l10n.searchCatalogNoResponse('${cat.error}'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Pm.muted, fontSize: 12),
                  ),
          );
        }
        return ListView(
          padding: isCompact(context)
              ? const EdgeInsets.fromLTRB(8, 8, 8, 32)
              : const EdgeInsets.fromLTRB(24, 12, 24, 48),
          children: [
            ChipBar(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              children: [
                for (final t in _Tab.values)
                  Chip2(
                    switch (t) {
                      _Tab.all => context.l10n.commonAll,
                      _Tab.artists => context.l10n.commonArtists,
                      _Tab.tracks => context.l10n.commonSongs,
                      _Tab.albums => context.l10n.commonAlbums,
                      _Tab.playlists => context.l10n.commonPlaylists,
                    },
                    selected: _tab == t,
                    onTap: () => setState(() => _tab = t),
                  ),
              ],
            ),
            if (cat.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  context.l10n.searchAlsoCatalog,
                  style: TextStyle(color: Pm.muted, fontSize: 12),
                ),
              )
            else if (cat.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  context.l10n.searchLibraryOnly('${cat.error}'),
                  style: TextStyle(color: Pm.muted, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            ...switch (_tab) {
              _Tab.all => _all(r, q),
              _Tab.artists => [_grid(r.artists)],
              _Tab.albums => [_grid(r.albums)],
              _Tab.playlists => [_grid(r.playlists)],
              _Tab.tracks => [
                TrackTable(
                  tracks: r.tracks,
                  contextName: context.l10n.audioSearchContext(q),
                ),
              ],
            },
          ],
        );
      },
    );
  }

  List<Widget> _all(SearchResults r, String q) {
    final top = r.top!;
    return [
      LayoutBuilder(
        builder: (_, c) {
          final wide = c.maxWidth > 900;
          final topCard = _TopResult(top);
          final songs = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(context.l10n.commonSongs),
              for (var i = 0; i < r.tracks.length && i < 4; i++)
                TrackRow(
                  track: r.tracks[i],
                  number: i + 1,
                  showAlbum: false,
                  onPlay: () => ref
                      .read(playerProvider.notifier)
                      .playList(
                        r.tracks,
                        start: i,
                        contextName: context.l10n.audioSearchContext(q),
                      ),
                ),
            ],
          );
          if (!wide) {
            return Column(
              children: [topCard, const SizedBox(height: 24), songs],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: topCard),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: r.tracks.isEmpty ? const SizedBox() : songs,
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 32),
      Shelf(title: context.l10n.commonArtists, items: r.artists),
      Shelf(title: context.l10n.commonAlbums, items: r.albums),
      Shelf(title: context.l10n.commonPlaylists, items: r.playlists),
    ];
  }

  Widget _grid(List<Item> items) =>
      Wrap(children: [for (final i in items) MediaCard(i)]);
}

/// "Top result": large card.
class _TopResult extends ConsumerStatefulWidget {
  final Item item;
  const _TopResult(this.item);
  @override
  ConsumerState<_TopResult> createState() => _TopResultState();
}

class _TopResultState extends ConsumerState<_TopResult> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(context.l10n.searchTopResult),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: () => context.go(routeFor(it)),
            onSecondaryTapDown: (d) =>
                showItemMenu(context, ref, it, d.globalPosition),
            child: Container(
              height: 230,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _hover ? Pm.highlight : Pm.elevated,
                borderRadius: BorderRadius.circular(Pm.radius),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Cover(it, size: 92, round: it.kind == ItemKind.artist),
                      const SizedBox(height: 20),
                      Text(
                        it.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        it.kind == ItemKind.artist
                            ? context.l10n.commonArtist
                            : '${it.typeLabel} • ${it.artistLine}',
                        style: TextStyle(color: Pm.subdued),
                      ),
                    ],
                  ),
                  if (_hover)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GreenPlayButton(
                        onPressed: () => playItem(ref, it),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Empty search: recent searches and "Browse all sections".
class _Browse extends ConsumerWidget {
  const _Browse();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    final lib = ref.watch(libraryProvider).value;
    final pls = lib?.playlists ?? const <Item>[];
    final tiles = <(String, Color, VoidCallback)>[
      (
        context.l10n.commonLikedSongs,
        const Color(0xFF5038A0),
        () => context.go('/collection/tracks'),
      ),
      for (final p in pls.where((p) => p.name.startsWith('Descobertas')))
        (
          p.name,
          const Color(0xFF148A08),
          () => context.go('/playlist/${p.id}'),
        ),
      (
        context.l10n.searchSpotifyPlaylists,
        const Color(0xFF1E3264),
        () => context.go('/search?q=${Uri.encodeQueryComponent('Spotify ·')}'),
      ),
      (context.l10n.commonHome, const Color(0xFFE8115B), () => context.go('/')),
    ];
    final compact = isCompact(context);
    final tileW = compact
        ? (MediaQuery.sizeOf(context).width - 16 * 2 - 12) / 2
        : 200.0;
    return ListView(
      padding: compact
          ? const EdgeInsets.fromLTRB(16, 8, 16, 32)
          : const EdgeInsets.fromLTRB(24, 16, 24, 48),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: SectionHeader(context.l10n.searchRecent)),
              TextLink(
                context.l10n.searchClear,
                style: TextStyle(
                  color: Pm.subdued,
                  fontWeight: FontWeight.w700,
                ),
                onTap: () => ref.read(recentSearchesProvider.notifier).clear(),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in recent)
                Chip2(
                  s,
                  gap: 0,
                  selected: false,
                  onTap: () =>
                      context.go('/search?q=${Uri.encodeQueryComponent(s)}'),
                ),
            ],
          ),
          const SizedBox(height: 32),
        ],
        SectionHeader(context.l10n.searchBrowseAll),
        Wrap(
          spacing: compact ? 12 : 16,
          runSpacing: compact ? 12 : 16,
          children: [
            for (final t in tiles)
              GestureDetector(
                onTap: t.$3,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: tileW,
                    height: compact ? 96 : 120,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: t.$2,
                      borderRadius: BorderRadius.circular(Pm.radius),
                    ),
                    child: Text(
                      t.$1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// "What do you want to listen to?" field at the top of the phone search.
class _MobileSearchField extends StatefulWidget {
  final String query;
  const _MobileSearchField({required this.query});
  @override
  State<_MobileSearchField> createState() => _MobileSearchFieldState();
}

class _MobileSearchFieldState extends State<_MobileSearchField> {
  late final _ctrl = TextEditingController(text: widget.query);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _go(String v) {
    final q = v.trim();
    context.go(
      q.isEmpty ? '/search' : '/search?q=${Uri.encodeQueryComponent(q)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sb = searchBox(focused: true, phone: true);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UserAvatar(),
              const SizedBox(width: 12),
              Text(
                context.l10n.commonSearch,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 46,
            decoration: sb.box,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search, color: sb.text.withValues(alpha: 0.85)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: sb.text, fontSize: 15),
                    cursorColor: sb.text,
                    decoration: InputDecoration(
                      hintText: context.l10n.searchHint,
                      hintStyle: TextStyle(color: sb.hint),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      setState(() {});
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 350),
                        () => _go(v),
                      );
                    },
                    onSubmitted: _go,
                  ),
                ),
                if (_ctrl.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.close, color: sb.text),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() {});
                      _go('');
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
