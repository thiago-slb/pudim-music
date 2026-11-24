import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../responsive.dart';
import '../theme.dart';
import 'actions.dart';
import 'common.dart';

/// Album/playlist/artist card: cover, title and subtitle, green button on mouse hover.
class MediaCard extends ConsumerStatefulWidget {
  final Item item;
  final String? subtitle;
  final double width;
  final double padding;
  const MediaCard(
    this.item, {
    super.key,
    this.subtitle,
    this.width = 180,
    this.padding = 12,
  });

  @override
  ConsumerState<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends ConsumerState<MediaCard> {
  bool _hover = false;

  String get _subtitle {
    final it = widget.item;
    if (widget.subtitle != null) return widget.subtitle!;
    return switch (it.kind) {
      ItemKind.artist => context.l10n.commonArtist,
      ItemKind.album => [
        if (it.year != null) '${it.year}',
        it.artistLine,
      ].join(' • '),
      ItemKind.playlist =>
        it.childCount != null
            ? context.l10n.commonSongCount(it.childCount!)
            : context.l10n.commonPlaylist,
      ItemKind.track => it.artistLine,
      ItemKind.other => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final round = it.kind == ItemKind.artist;
    final q = ref.watch(playerProvider);
    final isCtx = q.contextRoute == routeFor(it);
    final playingHere = isCtx && q.playing;
    final coverSize = widget.width - widget.padding * 2;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go(routeFor(it)),
        onSecondaryTapDown: (d) =>
            showItemMenu(context, ref, it, d.globalPosition),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            color: _hover ? Pm.highlight : Colors.transparent,
            borderRadius: BorderRadius.circular(Pm.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Cover(
                    it,
                    size: coverSize,
                    round: round,
                    radius: Pm.current.coverRadius,
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: AnimatedSlide(
                      offset: _hover || playingHere
                          ? Offset.zero
                          : const Offset(0, 0.25),
                      duration: const Duration(milliseconds: 150),
                      child: AnimatedOpacity(
                        opacity: _hover || playingHere ? 1 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: GreenPlayButton(
                          size: 48,
                          playing: playingHere,
                          onPressed: () {
                            if (isCtx) {
                              ref.read(playerProvider.notifier).togglePlay();
                            } else {
                              playItem(ref, it);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                it.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (it.cloud)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: CloudBadge(),
                    ),
                  Expanded(
                    child: Text(
                      _subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pm.subdued, fontSize: 13.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal row of cards, with arrows to scroll.
class Shelf extends StatefulWidget {
  final String title;
  final String? overline;
  final String? subtitle;
  final List<Item> items;
  final String Function(Item)? subtitleOf;
  final VoidCallback? onShowAll;
  const Shelf({
    super.key,
    required this.title,
    required this.items,
    this.overline,
    this.subtitle,
    this.subtitleOf,
    this.onShowAll,
  });

  @override
  State<Shelf> createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  final _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _scroll(double delta) => _ctrl.animateTo(
    (_ctrl.offset + delta).clamp(0, _ctrl.position.maxScrollExtent),
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final compact = isCompact(context);
    return Padding(
      // On the phone the covers sit closer together and the sections are tighter.
      padding: EdgeInsets.only(bottom: compact ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 12),
            child: SectionHeader(
              widget.title,
              overline: widget.overline,
              subtitle: widget.subtitle,
              onShowAll: widget.onShowAll,
            ),
          ),
          SizedBox(
            height: compact
                ? 154 + 62 * MediaQuery.textScalerOf(context).scale(1)
                : 270,
            child: Stack(
              children: [
                ListView.builder(
                  controller: _ctrl,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  itemBuilder: (_, i) => MediaCard(
                    widget.items[i],
                    width: compact ? 144 : 180,
                    padding: compact ? 6 : 12,
                    subtitle: widget.subtitleOf?.call(widget.items[i]),
                  ),
                ),
                if (!compact) ...[
                  Positioned(
                    right: 4,
                    top: 80,
                    child: _Arrow(Icons.chevron_right, () => _scroll(600)),
                  ),
                  Positioned(
                    left: 4,
                    top: 80,
                    child: _Arrow(Icons.chevron_left, () => _scroll(-600)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Arrow(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Material(
    color: Pm.elevated.withValues(alpha: 0.9),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Pm.text, size: 22),
      ),
    ),
  );
}

/// Shortcut of the Home top grid (small cover + name).
class QuickTile extends ConsumerStatefulWidget {
  final Item item;
  const QuickTile(this.item, {super.key});
  @override
  ConsumerState<QuickTile> createState() => _QuickTileState();
}

class _QuickTileState extends ConsumerState<QuickTile> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final q = ref.watch(playerProvider);
    final isCtx = q.contextRoute == routeFor(it);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go(routeFor(it)),
        onSecondaryTapDown: (d) =>
            showItemMenu(context, ref, it, d.globalPosition),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _hover ? Colors.white24 : Colors.white12,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Cover(it, size: 56, radius: 0, round: it.kind == ItemKind.artist),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  it.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isCtx ? Pm.accent : Pm.text,
                  ),
                ),
              ),
              if (_hover || (isCtx && q.playing))
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GreenPlayButton(
                    size: 36,
                    playing: isCtx && q.playing,
                    onPressed: () => isCtx
                        ? ref.read(playerProvider.notifier).togglePlay()
                        : playItem(ref, it),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
