import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/library.dart';
import '../../state/offline.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/offline_button.dart';
import '../../ui/widgets/page_header.dart';
import '../../ui/widgets/track_table.dart';
import '../../ui/widgets/mix_button.dart';
import 'playlist_edit.dart';

/// Rótulo da origem da playlist, a partir do prefixo que o painel usa.
String playlistOrigin(String name) {
  if (name.startsWith('Spotify · ')) return 'Do Spotify';
  if (name == 'Descobertas da semana' ||
      name == 'Mistura da semana' ||
      name == 'Radar de Novidades' ||
      name.startsWith('daylist · ')) {
    return 'Feita para você';
  }
  if (name.startsWith('Blend · ')) return 'Blend';
  if (name.endsWith('_automatic')) return 'Mix automático';
  return 'Playlist';
}

class PlaylistPage extends ConsumerWidget {
  final String id;
  const PlaylistPage(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(playlistProvider(id));
    final userName = ref.watch(sessionProvider).value?.userName ?? '';
    final off = ref.watch(offlineProvider);
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => off.saved(id)
          ? _offlineTracks(off, id, '/playlist/$id', userName)
          : ErrorBox(e, onRetry: () => ref.invalidate(playlistProvider(id))),
      data: (d) {
        Future.microtask(() => ref.read(recentOpenProvider.notifier).touch(id));
        final api = ref.watch(apiProvider);
        final p = d.playlist;
        final collab = ref.watch(collabProvider(id)).value;
        final editable = !isGeneratedPlaylist(p.name);
        return TracksPage(
          title: p.name,
          type: playlistOrigin(p.name),
          cover: Cover(p, size: 232),
          colorFromUrl: api.imageUrl(p.id, size: 64),
          description: (p.overview ?? '').isEmpty ? null : Text(p.overview!),
          above: CollabMembers(id),
          playlistId: editable ? id : null,
          addedBy: collab != null && collab.isCollab
              ? (t) => collab.who(t.id)?.displayName
              : null,
          smart: true,
          owner: userName,
          tracks: d.tracks,
          route: '/playlist/$id',
          item: p,
          offlineId: id,
          extra: [if (mixKindOf(p.name) case final k?) MixButton(k)],
        );
      },
    );
  }
}

/// Músicas curtidas (favoritos do usuário).
class LikedPage extends ConsumerWidget {
  const LikedPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(likedTracksProvider);
    final userName = ref.watch(sessionProvider).value?.userName ?? '';
    final off = ref.watch(offlineProvider);
    return data.when(
      loading: () => const LoadingBox(),
      error: (e, _) => off.saved('liked')
          ? _offlineTracks(off, 'liked', '/collection/tracks', userName)
          : ErrorBox(e, onRetry: () => ref.invalidate(likedTracksProvider)),
      data: (tracks) => TracksPage(
        title: 'Músicas curtidas',
        type: 'Playlist',
        cover: Container(
          width: 232,
          height: 232,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF450AF5), Color(0xFFC4EFD9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.favorite, size: 80, color: Colors.white),
        ),
        color: const Color(0xFF5038A0),
        owner: userName,
        tracks: tracks,
        route: '/collection/tracks',
        showDateAdded: true,
        offlineId: 'liked',
      ),
    );
  }
}

/// Sem internet: a mesma página com o que foi guardado no aparelho.
Widget _offlineTracks(OfflineState off, String id, String route, String owner) {
  final c = off.collections[id]!;
  return TracksPage(
    title: c.name,
    type: 'Baixada no aparelho',
    cover: c.head == null
        ? const OfflineCover(size: 232)
        : Cover(c.head, size: 232),
    color: const Color(0xFF1E3A2A),
    owner: owner,
    tracks: off.tracksOf(id),
    route: route,
    offlineId: id,
  );
}

/// Todas as músicas baixadas no aparelho.
class OfflinePage extends ConsumerWidget {
  const OfflinePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final off = ref.watch(offlineProvider);
    final userName = ref.watch(sessionProvider).value?.userName ?? '';
    final tracks = off.tracks.values.toList()
      ..sort((a, b) => a.artistLine.compareTo(b.artistLine));
    return TracksPage(
      title: 'Baixadas',
      type: 'No aparelho',
      cover: const OfflineCover(size: 232),
      color: const Color(0xFF1E3A2A),
      owner: userName,
      description: off.pending.isEmpty
          ? const Text('Tocam sem internet.')
          : Text('Tocam sem internet. Baixando mais ${off.pending.length}…'),
      tracks: tracks,
      route: '/collection/offline',
    );
  }
}

/// Capa da "Baixadas": seta verde.
class OfflineCover extends StatelessWidget {
  final double size;
  const OfflineCover({super.key, this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size < 100 ? 4 : 0),
      gradient: const LinearGradient(
        colors: [Color(0xFF0D7A3A), Color(0xFF1ED760)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Icon(Icons.arrow_circle_down, size: size * 0.4, color: Colors.white),
  );
}

/// Página genérica de lista de faixas (playlist, curtidas).
class TracksPage extends ConsumerStatefulWidget {
  final String title;
  final String type;
  final Widget cover;
  final String? colorFromUrl;
  final Color? color;
  final Widget? description;
  final String owner;
  final List<Item> tracks;
  final String route;
  final Item? item;
  final bool showDateAdded;
  const TracksPage({
    super.key,
    required this.title,
    required this.type,
    required this.cover,
    required this.owner,
    required this.tracks,
    required this.route,
    this.colorFromUrl,
    this.color,
    this.description,
    this.item,
    this.showDateAdded = false,
    this.offlineId,
    this.extra = const [],
    this.above,
    this.playlistId,
    this.addedBy,
    this.smart = false,
  });

  /// Linha acima dos dados (ex.: quem participa da playlist colaborativa).
  final Widget? above;

  /// Playlist editável: as faixas ganham "Remover desta playlist".
  final String? playlistId;

  /// Colaborativa: quem adicionou cada faixa.
  final String? Function(Item)? addedBy;

  /// Mostrar o botão de Smart Shuffle.
  final bool smart;

  /// Botões a mais na barra (ex.: "Refazer" das Descobertas).
  final List<Widget> extra;

  /// Id para "Baixar no aparelho" (sem ele a página não tem o botão).
  final String? offlineId;

  @override
  ConsumerState<TracksPage> createState() => _TracksPageState();
}

class _TracksPageState extends ConsumerState<TracksPage> {
  String _filter = '';
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final q = ref.watch(playerProvider);
    final isCtx = q.contextRoute == widget.route;
    final total = widget.tracks.fold(Duration.zero, (s, t) => s + t.duration);
    final f = _filter.toLowerCase();
    final shown = f.isEmpty
        ? widget.tracks
        : widget.tracks
              .where(
                (t) =>
                    t.name.toLowerCase().contains(f) ||
                    t.artistLine.toLowerCase().contains(f) ||
                    (t.album ?? '').toLowerCase().contains(f),
              )
              .toList();
    final player = ref.read(playerProvider.notifier);
    return GradientPage(
      colorFromUrl: widget.colorFromUrl,
      color: widget.color,
      children: [
        BigHeader(
          cover: widget.cover,
          type: widget.type,
          title: widget.title,
          description: widget.description,
          meta: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ?widget.above,
              Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.owner,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' • ${widget.tracks.length} músicas, ${formatTotal(total)}',
                  style: const TextStyle(color: Pm.subdued),
                ),
              ],
            ),
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
                      widget.tracks,
                      contextName: widget.title,
                      contextRoute: widget.route,
                    ),
            ),
            const SizedBox(width: 16),
            IconBtn(
              Icons.shuffle,
              tooltip: 'Tocar em ordem aleatória',
              size: 32,
              onPressed: () => player.shufflePlay(
                widget.tracks,
                contextName: widget.title,
                contextRoute: widget.route,
              ),
            ),
            if (widget.smart && widget.tracks.length > 2)
              SmartShuffleButton(
                tracks: widget.tracks,
                title: widget.title,
                route: widget.route,
              ),
            ...widget.extra,
            if (widget.offlineId != null)
              OfflineButton(
                id: widget.offlineId!,
                name: widget.title,
                head: widget.item,
                tracks: widget.tracks,
              ),
            if (widget.item != null)
              Builder(
                builder: (bctx) => IconBtn(
                  Icons.more_horiz,
                  tooltip: 'Mais opções para ${widget.title}',
                  size: 32,
                  onPressed: () {
                    final box = bctx.findRenderObject() as RenderBox;
                    showItemMenu(
                      context,
                      ref,
                      widget.item!,
                      box.localToGlobal(box.size.bottomLeft(Offset.zero)),
                    );
                  },
                ),
              ),
            const Spacer(),
            if (_searching)
              Container(
                width: 220,
                height: 34,
                decoration: BoxDecoration(
                  color: Pm.highlight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.search, size: 18, color: Pm.subdued),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Buscar na playlist',
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _filter = v),
                      ),
                    ),
                  ],
                ),
              )
            else
              IconBtn(
                Icons.search,
                tooltip: 'Buscar na playlist',
                onPressed: () => setState(() => _searching = true),
              ),
          ],
        ),
        PageBody(
          child: widget.tracks.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nenhuma música por aqui ainda.',
                    style: TextStyle(color: Pm.subdued),
                  ),
                )
              : TrackTable(
                  tracks: shown,
                  contextName: widget.title,
                  contextRoute: widget.route,
                  showDateAdded: widget.showDateAdded,
                  playlistId: widget.playlistId,
                  addedBy: widget.addedBy,
                ),
        ),
      ],
    );
  }
}
