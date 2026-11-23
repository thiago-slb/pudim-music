import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Coluna "Sua Biblioteca".
class LibrarySidebar extends ConsumerWidget {
  const LibrarySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = isCompact(context);
    final collapsed = !compact && ref.watch(sidebarCollapsedProvider);
    final lib = ref.watch(libraryProvider);
    final liked = ref.watch(likedTracksProvider).value;
    final filter = ref.watch(libFilterProvider);
    final sort = ref.watch(libSortProvider);
    final query = ref.watch(libQueryProvider).toLowerCase();
    final recent = ref.watch(recentOpenProvider);
    final off = ref.watch(offlineProvider);
    // Sem internet: a biblioteca vira o que está guardado no aparelho.
    final offlineOnly = lib.hasError && off.collections.isNotEmpty;

    final entries = <_Entry>[];
    final data = lib.value;
    if (offlineOnly) {
      entries.add(_Entry.offline(off.tracks.length));
      for (final c in off.collections.values) {
        if (c.id == 'liked') {
          entries.add(_Entry.liked(off.tracksOf('liked').length));
        } else if (c.head != null) {
          entries.add(_Entry.item(c.head!));
        }
      }
    } else if (data != null) {
      if (filter == LibFilter.all || filter == LibFilter.playlists) {
        entries.add(_Entry.liked(liked?.length ?? 0));
        if (off.tracks.isNotEmpty) {
          entries.add(_Entry.offline(off.tracks.length));
        }
        entries.addAll(data.playlists.map(_Entry.item));
      }
      if (filter == LibFilter.all || filter == LibFilter.albums) {
        entries.addAll(data.albums.map(_Entry.item));
      }
      if (filter == LibFilter.all || filter == LibFilter.artists) {
        entries.addAll(data.artists.map(_Entry.item));
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

    return Container(
      decoration: BoxDecoration(
        color: Pm.base,
        borderRadius: BorderRadius.circular(Pm.radius),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(collapsed ? 8 : 16, 12, 8, 4),
            child: compact
                ? const Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: Row(
                      children: [
                        UserAvatar(),
                        SizedBox(width: 12),
                        Text(
                          'Sua Biblioteca',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      IconBtn(
                        Icons.view_sidebar_outlined,
                        tooltip: collapsed
                            ? 'Abrir Sua Biblioteca'
                            : 'Recolher Sua Biblioteca',
                        onPressed: () => ref
                            .read(sidebarCollapsedProvider.notifier)
                            .toggle(),
                      ),
                      if (!collapsed) ...[
                        const Expanded(
                          child: Text(
                            'Sua Biblioteca',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
          if (!collapsed) ...[
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                children: [
                  for (final f in [
                    LibFilter.playlists,
                    LibFilter.albums,
                    LibFilter.artists,
                  ])
                    // A lista horizontal estica os filhos até os 40 px de altura: sem o Center
                    // o texto ficava grudado em cima, com sobra embaixo.
                    Center(
                      child: Chip2(
                        switch (f) {
                          LibFilter.playlists => 'Playlists',
                          LibFilter.albums => 'Álbuns',
                          LibFilter.artists => 'Artistas',
                          LibFilter.all => 'Tudo',
                        },
                        selected: filter == f,
                        onTap: () => ref
                            .read(libFilterProvider.notifier)
                            .set(filter == f ? LibFilter.all : f),
                      ),
                    ),
                ],
              ),
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

  factory _Entry.offline(int n) => _Entry(
    'offline',
    'Baixadas',
    'No aparelho • $n músicas',
    null,
    isOffline: true,
  );

  factory _Entry.liked(int n) => _Entry(
    'liked',
    'Músicas curtidas',
    'Playlist • $n músicas',
    null,
    isLiked: true,
  );

  factory _Entry.item(Item it) => _Entry(it.id, it.name, switch (it.kind) {
    ItemKind.playlist => 'Playlist',
    ItemKind.album => 'Álbum • ${it.artistLine}',
    ItemKind.artist => 'Artista',
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
        : Cover(e.item, size: 48, round: e.item!.kind == ItemKind.artist);
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white12
                  : _hover
                  ? Colors.white10
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
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
                            fontSize: 15,
                            color: playingHere ? Pm.green : Pm.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Pm.subdued,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (playingHere && q.playing)
                    const Icon(Icons.volume_up, color: Pm.green, size: 16),
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
        tooltip: 'Buscar na Sua Biblioteca',
        size: 18,
        onPressed: () => setState(() => _open = true),
      );
    }
    return Container(
      width: 180,
      height: 32,
      decoration: BoxDecoration(
        color: Pm.highlight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, size: 16, color: Pm.subdued),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Buscar na Sua Biblioteca',
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
    String label(LibSort s) => switch (s) {
      LibSort.recents => 'Recentes',
      LibSort.added => 'Adicionados recentemente',
      LibSort.alpha => 'Alfabética',
      LibSort.creator => 'Criador',
    };
    return PopupMenuButton<LibSort>(
      tooltip: 'Ordenar por',
      onSelected: (s) => ref.read(libSortProvider.notifier).set(s),
      itemBuilder: (_) => [
        const PopupMenuItem(
          enabled: false,
          child: Text(
            'Ordenar por',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
                    style: TextStyle(color: s == sort ? Pm.green : Pm.text),
                  ),
                ),
                if (s == sort)
                  const Icon(Icons.check, color: Pm.green, size: 18),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Text(
              label(sort),
              style: const TextStyle(color: Pm.subdued, fontSize: 13),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.format_list_bulleted, size: 16, color: Pm.subdued),
          ],
        ),
      ),
    );
  }
}

/// Usado na rota de Músicas curtidas e na contagem.
final likedCountProvider = Provider<int>(
  (ref) => ref.watch(likedTracksProvider).value?.length ?? 0,
);
