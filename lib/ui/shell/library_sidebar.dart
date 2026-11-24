import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../features/playlist/playlist_page.dart';
import '../../state/library.dart';
import '../../state/offline.dart';
import '../../state/ui.dart';
import '../responsive.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import '../widgets/theme_bits.dart';
import '../widgets/themed.dart';
import '../widgets/page_header.dart';

enum LibFilter { all, playlists, albums, artists }

enum LibSort { recents, added, alpha, creator }

final libFilterProvider = NotifierProvider<_Val<LibFilter>, LibFilter>(
  () => _Val(LibFilter.all),
);
final libSortProvider = NotifierProvider<_Val<LibSort>, LibSort>(
  () => _Val(LibSort.recents),
);
final libQueryProvider = NotifierProvider<_Val<String>, String>(() => _Val(''));

class _Val<T> extends Notifier<T> {
  final T initial;
  _Val(this.initial);
  @override
  T build() => initial;
  void set(T v) => state = v;
}

/// "Your Library" column.
class LibrarySidebar extends ConsumerWidget {
  const LibrarySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final compact = isCompact(context);
    final collapsed = !compact && ref.watch(sidebarCollapsedProvider);
    final lib = ref.watch(libraryProvider);
    final liked = ref.watch(likedTracksProvider).value;
    final filter = ref.watch(libFilterProvider);
    final sort = ref.watch(libSortProvider);
    final query = ref.watch(libQueryProvider).toLowerCase();
    final recent = ref.watch(recentOpenProvider);
    final off = ref.watch(offlineProvider);
    // No internet: the library becomes what is stored on the device.
    final offlineOnly = lib.hasError && off.collections.isNotEmpty;

    final entries = <_Entry>[];
    final data = lib.value;
    if (offlineOnly) {
      entries.add(_Entry.offline(l10n, off.tracks.length));
      for (final c in off.collections.values) {
        if (c.id == 'liked') {
          entries.add(_Entry.liked(l10n, off.tracksOf('liked').length));
        } else if (c.head != null) {
          entries.add(_Entry.item(l10n, c.head!));
        }
      }
    } else if (data != null) {
      if (filter == LibFilter.all || filter == LibFilter.playlists) {
        entries.add(_Entry.liked(l10n, liked?.length ?? 0));
        if (off.tracks.isNotEmpty) {
          entries.add(_Entry.offline(l10n, off.tracks.length));
        }
        entries.addAll(data.playlists.map((i) => _Entry.item(l10n, i)));
      }
      if (filter == LibFilter.all || filter == LibFilter.albums) {
        entries.addAll(data.albums.map((i) => _Entry.item(l10n, i)));
      }
      if (filter == LibFilter.all || filter == LibFilter.artists) {
        entries.addAll(data.artists.map((i) => _Entry.item(l10n, i)));
      }
    }
    var shown = entries
        .where((e) => query.isEmpty || e.title.toLowerCase().contains(query))
        .toList();
    int rank(_Entry e) {
      final i = recent.indexOf(e.id);
      return i < 0 ? 1 << 20 : i;
    }

    switch (sort) {
      case LibSort.recents:
        shown.sort((a, b) {
          int pin(_Entry e) => e.isLiked ? 0 : (e.isOffline ? 1 : 2);
          final p = pin(a).compareTo(pin(b));
          return p != 0 ? p : rank(a).compareTo(rank(b));
        });
      case LibSort.added:
        shown.sort(
          (a, b) => (b.item?.dateCreated ?? DateTime(1970)).compareTo(
            a.item?.dateCreated ?? DateTime(1970),
          ),
        );
      case LibSort.alpha:
        shown.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case LibSort.creator:
        shown.sort((a, b) => a.subtitle.compareTo(b.subtitle));
    }

    final t = Pm.current;
    // Same backdrop as the inner pages: the theme's gradient fading into the base color at the
    // top of the panel (gray window in retro, flat in ruby).
    final g = pageGradient(t.highlight);
    return Container(
      decoration: t.style == UiStyle.retro
          ? bevel(color: t.base)
          : BoxDecoration(
              borderRadius: BorderRadius.circular(Pm.radius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: g,
                stops: const [0, 0.22, 0.5],
              ),
            ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(collapsed ? 8 : 16, 12, 8, 4),
            child: compact
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Row(
                      children: [
                        const UserAvatar(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: pageTitle(
                            l10n.commonYourLibrary,
                            24,
                            compact: true,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      IconBtn(
                        Icons.view_sidebar_outlined,
                        tooltip: collapsed
                            ? l10n.sidebarOpenLibrary
                            : l10n.sidebarCollapseLibrary,
                        onPressed: () => ref
                            .read(sidebarCollapsedProvider.notifier)
                            .toggle(),
                      ),
                      if (!collapsed) ...[
                        Expanded(child: SmallHeading(l10n.commonYourLibrary)),
                      ],
                    ],
                  ),
          ),
          if (!collapsed) ...[
            // Same pill row as the rest of the app: each pill as wide as its label, one
            // sideways-scrolling line that grows with large system fonts.
            PillBar(
              scroll: true,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              children: [
                for (final f in [
                  LibFilter.playlists,
                  LibFilter.albums,
                  LibFilter.artists,
                ])
                  Chip2(
                    switch (f) {
                      LibFilter.playlists => l10n.commonPlaylists,
                      LibFilter.albums => l10n.commonAlbums,
                      LibFilter.artists => l10n.commonArtists,
                      LibFilter.all => l10n.commonAll,
                    },
                    selected: filter == f,
                    onTap: () => ref
                        .read(libFilterProvider.notifier)
                        .set(filter == f ? LibFilter.all : f),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
              child: Row(
                children: [
                  const _LibSearch(),
                  const Spacer(),
                  _SortMenu(sort: sort),
                ],
              ),
            ),
          ],
          Expanded(
            child: lib.when(
              loading: () => const LoadingBox(),
              error: (e, _) => offlineOnly
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: shown.length,
                      itemBuilder: (_, i) =>
                          _LibRow(shown[i], collapsed: collapsed),
                    )
                  : ErrorBox(e, onRetry: () => ref.invalidate(libraryProvider)),
              data: (_) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: shown.length,
                itemBuilder: (_, i) => _LibRow(shown[i], collapsed: collapsed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry {
  final String id;
  final String title;
  final String subtitle;
  final Item? item;
  final bool isLiked;
  final bool isOffline;
  _Entry(
    this.id,
    this.title,
    this.subtitle,
    this.item, {
    this.isLiked = false,
    this.isOffline = false,
  });

  factory _Entry.offline(L10n l10n, int n) => _Entry(
    'offline',
    l10n.commonDownloaded,
    l10n.sidebarOnDeviceCount(n),
    null,
    isOffline: true,
  );

  factory _Entry.liked(L10n l10n, int n) => _Entry(
    'liked',
    l10n.commonLikedSongs,
    l10n.sidebarPlaylistCount(n),
    null,
    isLiked: true,
  );

  factory _Entry.item(L10n l10n, Item it) =>
      _Entry(it.id, it.name, switch (it.kind) {
        ItemKind.playlist => l10n.commonPlaylist,
        ItemKind.album => l10n.sidebarAlbumBy(it.artistLine),
        ItemKind.artist => l10n.commonArtist,
        _ => '',
      }, it);

  String get route => isLiked
      ? '/collection/tracks'
      : isOffline
      ? '/collection/offline'
      : routeFor(item!);
}

class _LibRow extends ConsumerStatefulWidget {
  final _Entry e;
  final bool collapsed;
  const _LibRow(this.e, {required this.collapsed});
  @override
  ConsumerState<_LibRow> createState() => _LibRowState();
}

class _LibRowState extends ConsumerState<_LibRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.e;
    final path = GoRouterState.of(context).uri.path;
    final selected = path == e.route;
    final q = ref.watch(playerProvider);
    final playingHere = q.contextRoute == e.route;
    final t = Pm.current;
    final st = t.style;
    // Selected/hover row: soft tint (night), rounded gray (ruby), gradient pill (wave), sunken
    // black LCD line (retro) or a glossy bar (glass).
    final Decoration rowDeco = switch (st) {
      UiStyle.retro when selected => bevel(pressed: true, color: Colors.black),
      UiStyle.retro => BoxDecoration(
        color: _hover ? t.highlight : Colors.transparent,
      ),
      UiStyle.wave when selected => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [t.accent.withValues(alpha: 0.55), Colors.transparent],
        ),
      ),
      UiStyle.glass when selected => glass(
        radius: BorderRadius.circular(8),
      ).copyWith(boxShadow: const []),
      UiStyle.ruby => BoxDecoration(
        color: selected
            ? const Color(0x24FFFFFF)
            : _hover
            ? Colors.white10
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      _ => BoxDecoration(
        color: selected
            ? Colors.white12
            : _hover
            ? Colors.white10
            : Colors.transparent,
        borderRadius: BorderRadius.circular(st == UiStyle.wave ? 16 : 6),
      ),
    };
    final titleColor = playingHere
        ? (st == UiStyle.glass && selected ? Colors.white : Pm.accent)
        : (st == UiStyle.retro && selected ? Pm.accent : Pm.text);
    final cover = e.isOffline
        ? const OfflineCover()
        : e.isLiked
        ? Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [Color(0xFF450AF5), Color(0xFFC4EFD9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
          )
        : Cover(
            e.item,
            size: switch (st) {
              UiStyle.retro => 32,
              UiStyle.ruby => 56,
              _ => 48,
            },
            round: e.item!.kind == ItemKind.artist,
          );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go(e.route),
        onSecondaryTapDown: e.item == null
            ? null
            : (d) => showItemMenu(context, ref, e.item!, d.globalPosition),
        child: Tooltip(
          message: widget.collapsed ? e.title : '',
          child: Container(
            padding: EdgeInsets.all(st == UiStyle.retro ? 5 : 8),
            decoration: rowDeco,
            child: Row(
              children: [
                cover,
                if (!widget.collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: st == UiStyle.retro ? 13 : 15,
                            color: titleColor,
                            fontWeight: st == UiStyle.wave && selected
                                ? FontWeight.w800
                                : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Pm.subdued, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (playingHere && q.playing)
                    Icon(Icons.volume_up, color: Pm.accent, size: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibSearch extends ConsumerStatefulWidget {
  const _LibSearch();
  @override
  ConsumerState<_LibSearch> createState() => _LibSearchState();
}

class _LibSearchState extends ConsumerState<_LibSearch> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return IconBtn(
        Icons.search,
        tooltip: context.l10n.sidebarSearchLibrary,
        size: 18,
        onPressed: () => setState(() => _open = true),
      );
    }
    final sb = searchBox(focused: true, phone: false);
    return Container(
      width: 180,
      height: 32,
      decoration: Pm.current.style == UiStyle.night
          ? BoxDecoration(
              color: Pm.highlight,
              borderRadius: BorderRadius.circular(4),
            )
          : sb.box,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search, size: 16, color: sb.hint),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 13, color: sb.text),
              cursorColor: sb.text,
              decoration: InputDecoration(
                hintText: context.l10n.sidebarSearchLibrary,
                hintStyle: TextStyle(color: sb.hint),
                isDense: true,
              ),
              onChanged: (v) => ref.read(libQueryProvider.notifier).set(v),
              onTapOutside: (_) {
                if (ref.read(libQueryProvider).isEmpty) {
                  setState(() => _open = false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortMenu extends ConsumerWidget {
  final LibSort sort;
  const _SortMenu({required this.sort});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final retro = Pm.current.style == UiStyle.retro;
    String label(LibSort s) => switch (s) {
      LibSort.recents => l10n.sidebarSortRecents,
      LibSort.added => l10n.sidebarSortAdded,
      LibSort.alpha => l10n.sidebarSortAlpha,
      LibSort.creator => l10n.sidebarSortCreator,
    };
    return PopupMenuButton<LibSort>(
      tooltip: l10n.sidebarSortBy,
      onSelected: (s) => ref.read(libSortProvider.notifier).set(s),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            l10n.sidebarSortBy,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        for (final s in LibSort.values)
          PopupMenuItem(
            value: s,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label(s),
                    style: TextStyle(color: s == sort ? Pm.accent : Pm.text),
                  ),
                ),
                if (s == sort) Icon(Icons.check, color: Pm.accent, size: 18),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: _sortDeco(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              retro ? label(sort).toUpperCase() : label(sort),
              style: TextStyle(
                color: retro ? Pm.accent : Pm.subdued,
                fontSize: retro ? 12 : 13,
                letterSpacing: retro ? 1 : null,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.format_list_bulleted,
              size: 16,
              color: retro ? Pm.accent : Pm.subdued,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sort button frame: a raised key (retro), an outlined capsule (wave, glass), none otherwise.
Decoration? _sortDeco() {
  final t = Pm.current;
  return switch (t.style) {
    UiStyle.retro => bevel(),
    UiStyle.wave => BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: t.muted, width: 1.5),
    ),
    UiStyle.glass => BoxDecoration(
      color: t.elevated,
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: t.accent.withValues(alpha: 0.4)),
    ),
    UiStyle.night || UiStyle.ruby => null,
  };
}

/// Used on the Liked Songs route and in the count.
final likedCountProvider = Provider<int>(
  (ref) => ref.watch(likedTracksProvider).value?.length ?? 0,
);
