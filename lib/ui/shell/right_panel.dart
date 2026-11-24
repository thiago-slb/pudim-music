import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../features/lyrics/find_lyrics_button.dart';
import '../../features/lyrics/lyrics_data.dart';
import '../../state/session.dart';
import '../../state/ui.dart';
import '../colors.dart';
import '../responsive.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import '../widgets/track_table.dart';
import '../widgets/disk_image.dart';
import '../widgets/theme_bits.dart';
import '../widgets/themed.dart';

class RightPanelView extends ConsumerWidget {
  const RightPanelView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panel = ref.watch(rightPanelProvider);
    return Container(
      decoration: Pm.current.style == UiStyle.retro
          ? bevel(color: Pm.base)
          : BoxDecoration(
              color: Pm.base,
              borderRadius: BorderRadius.circular(Pm.radius),
            ),
      clipBehavior: Pm.current.style == UiStyle.retro
          ? Clip.none
          : Clip.antiAlias,
      child: switch (panel) {
        RightPanel.queue => const QueueView(),
        _ => const _NowPlayingPanel(),
      },
    );
  }
}

class _PanelHeader extends ConsumerWidget {
  final String title;
  const _PanelHeader(this.title);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 4, 4),
    child: Row(
      children: [
        Expanded(child: SmallHeading(title)),
        IconBtn(
          Icons.close,
          tooltip: context.l10n.commonClose,
          size: 18,
          onPressed: () {
            if (isCompact(context)) {
              Navigator.of(context).maybePop();
            } else {
              ref.read(rightPanelProvider.notifier).set(RightPanel.none);
            }
          },
        ),
      ],
    ),
  );
}

class _NowPlayingPanel extends ConsumerWidget {
  const _NowPlayingPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    if (cur == null) {
      return Column(
        children: [
          const _PanelHeader(''),
          Expanded(
            child: EmptyState(
              icon: Icons.music_note_rounded,
              title: context.l10n.rightPanelNothingPlaying,
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        _PanelHeader(q.contextName),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            children: [
              LayoutBuilder(
                builder: (_, c) => Cover(cur, size: c.maxWidth, radius: 8),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLink(
                          cur.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          onTap: cur.albumId == null
                              ? null
                              : () => context.go(routeFor(cur)),
                        ),
                        ArtistLinks(
                          cur,
                          style: TextStyle(color: Pm.subdued, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  IconBtn(
                    cur.favorite
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                    tooltip: cur.favorite
                        ? context.l10n.commonRemoveFromLiked
                        : context.l10n.commonAddToLiked,
                    active: cur.favorite,
                    size: 24,
                    onPressed: () => toggleFavorite(context, ref, cur),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LyricsPreview(cur),
              const SizedBox(height: 16),
              if (cur.mainArtist != null) AboutArtistCard(cur.mainArtist!),
              const SizedBox(height: 16),
              if (q.next != null) NextUpCard(q.next!),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Lyrics preview" card in the cover color.
class LyricsPreview extends ConsumerWidget {
  final Item track;
  const LyricsPreview(this.track, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyr = ref.watch(lyricsProvider(track.id)).value;
    if (lyr == null) return const SizedBox.shrink();
    if (lyr.isEmpty) {
      // No lyrics yet: offer to look them up, in the card's place.
      return Align(
        alignment: Alignment.centerLeft,
        child: FindLyricsButton(track, key: ValueKey(track.id)),
      );
    }
    final api = ref.watch(apiProvider);
    final url = api.imageUrl(track.imageItemId, size: 64);
    final color = url == null
        ? fallbackColor
        : (ref.watch(coverColorProvider(url)).value ?? fallbackColor);
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final idx = lyr.synced
        ? lyr.indexAt(pos).clamp(0, lyr.lines.length - 1)
        : 0;
    final lines = lyr.lines
        .skip(idx)
        .where((l) => l.text.isNotEmpty)
        .take(3)
        .toList();
    return GestureDetector(
      onTap: () =>
          context.push(isCompact(context) ? '/lyrics-full' : '/lyrics'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Pm.radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.rightPanelLyricsPreview,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < lines.length; i++)
                Text(
                  lines[i].text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.6,
                    fontWeight: FontWeight.w800,
                    color: i == 0
                        ? Colors.white
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutArtistCard extends ConsumerWidget {
  final NameId artist;
  const AboutArtistCard(this.artist, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final it = ref.watch(itemProvider(artist.id)).value;
    if (it == null) return const SizedBox.shrink();
    final api = ref.watch(apiProvider);
    final hasBackdrop = it.backdropTags.isNotEmpty;
    return GestureDetector(
      onTap: () {
        final router = GoRouter.of(context);
        if (isCompact(context)) router.pop();
        router.go('/artist/${artist.id}');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: panelDecoration(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: DiskImage(
                        api.imageUrl(
                          it.id,
                          type: hasBackdrop ? 'Backdrop' : 'Primary',
                          size: 600,
                        )!,
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, _, _) => Container(color: Pm.highlight),
                    ),
                    Positioned(
                      left: 16,
                      top: 12,
                      child: Text(
                        context.l10n.rightPanelAboutArtist,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(blurRadius: 8)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if ((it.overview ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _strip(it.overview!),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Pm.subdued, fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _strip(String s) => s.replaceAll(RegExp(r'<[^>]*>'), '');
}

class NextUpCard extends ConsumerWidget {
  final Item next;
  const NextUpCard(this.next, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.rightPanelNextUp,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextLink(
                context.l10n.rightPanelOpenQueue,
                style: TextStyle(
                  color: Pm.subdued,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                onTap: () => isCompact(context)
                    ? context.push('/queue')
                    : ref
                          .read(rightPanelProvider.notifier)
                          .set(RightPanel.queue),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Cover(next, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      next.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      next.artistLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pm.subdued, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Queue" panel: Now Playing, Up next in queue, Next from: `<context>`.
class QueueView extends ConsumerWidget {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final c = ref.read(playerProvider.notifier);
    final cur = q.current;
    Widget title(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
      child: SmallHeading(t),
    );
    Widget row(Item t, int queueIndex) => TrackRow(
      key: ValueKey('q$queueIndex-${t.id}'),
      track: t,
      number: queueIndex,
      showAlbum: false,
      queueIndex: queueIndex,
      onPlay: () => c.jumpTo(queueIndex),
    );
    if (cur == null) {
      return Column(
        children: [
          _PanelHeader(context.l10n.commonQueue),
          Expanded(
            child: EmptyState(
              icon: Icons.queue_music,
              title: context.l10n.rightPanelQueueEmptyTitle,
              subtitle: context.l10n.rightPanelQueueEmptyHint,
            ),
          ),
        ],
      );
    }
    final manual = q.manualNext;
    final rest = q.contextNext;
    final restStart = q.index + 1 + manual.length;
    return Column(
      children: [
        _PanelHeader(context.l10n.commonQueue),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              title(context.l10n.rightPanelNowPlaying),
              row(cur, q.index),
              if (manual.isNotEmpty) ...[
                title(context.l10n.rightPanelNextInQueue),
                for (var i = 0; i < manual.length; i++)
                  row(manual[i], q.index + 1 + i),
              ],
              if (rest.isNotEmpty) ...[
                title(
                  q.contextName.isEmpty
                      ? context.l10n.rightPanelNextUp
                      : context.l10n.rightPanelNextFrom(q.contextName),
                ),
                for (var i = 0; i < rest.length && i < 200; i++)
                  row(rest[i], restStart + i),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Full item (for "About the artist").
final itemProvider = FutureProvider.family<Item, String>(
  (ref, id) => ref.watch(apiProvider).item(id),
);
