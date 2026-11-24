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
import 'offline_button.dart';

/// Spotify-style track table: # / Title / Album / (Added on) / duration.
class TrackTable extends ConsumerWidget {
  final List<Item> tracks;
  final String contextName;
  final String? contextRoute;
  final bool showAlbum;
  final bool showCover;
  final bool showDateAdded;
  final bool useTrackNumbers;
  final bool showHeader;
  final int? limit;

  /// Editable playlist the tracks come from ("Remove from this playlist" in the menu).
  final String? playlistId;

  /// Collaborative: name of who added each track.
  final String? Function(Item)? addedBy;

  const TrackTable({
    super.key,
    required this.tracks,
    required this.contextName,
    this.contextRoute,
    this.showAlbum = true,
    this.showCover = true,
    this.showDateAdded = false,
    this.useTrackNumbers = false,
    this.showHeader = true,
    this.limit,
    this.playlistId,
    this.addedBy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = limit == null ? tracks : tracks.take(limit!).toList();
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth > 760;
        final compact = isCompact(context);
        return Column(
          children: [
            if (showHeader && !compact)
              _Header(
                showAlbum: showAlbum && wide,
                showDate: showDateAdded && wide,
              ),
            for (var i = 0; i < shown.length; i++)
              TrackRow(
                track: shown[i],
                number: useTrackNumbers ? (shown[i].index ?? i + 1) : i + 1,
                showAlbum: showAlbum && wide,
                showCover: showCover,
                showDate: showDateAdded && wide,
                playlistId: playlistId,
                addedBy: addedBy?.call(shown[i]),
                onPlay: () => ref
                    .read(playerProvider.notifier)
                    .playList(
                      tracks,
                      start: i,
                      contextName: contextName,
                      contextRoute: contextRoute,
                    ),
              ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final bool showAlbum;
  final bool showDate;
  const _Header({required this.showAlbum, required this.showDate});

  @override
  Widget build(BuildContext context) {
    final st = TextStyle(color: Pm.subdued, fontSize: 13.5);
    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('#', style: st, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Text(context.l10n.widgetTracksTitle, style: st),
          ),
          if (showAlbum)
            Expanded(flex: 3, child: Text(context.l10n.commonAlbum, style: st)),
          if (showDate)
            Expanded(
              flex: 2,
              child: Text(context.l10n.widgetTracksDateAdded, style: st),
            ),
          const SizedBox(width: 40),
          SizedBox(
            width: 56,
            child: Icon(Icons.schedule, size: 16, color: Pm.subdued),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class TrackRow extends ConsumerStatefulWidget {
  final Item track;
  final int number;
  final bool showAlbum;
  final bool showCover;
  final bool showDate;
  final VoidCallback onPlay;
  final int? queueIndex;
  final String? playlistId;
  final String? addedBy;
  const TrackRow({
    super.key,
    required this.track,
    required this.number,
    required this.onPlay,
    this.showAlbum = true,
    this.showCover = true,
    this.showDate = false,
    this.queueIndex,
    this.playlistId,
    this.addedBy,
  });

  @override
  ConsumerState<TrackRow> createState() => _TrackRowState();
}

class _TrackRowState extends ConsumerState<TrackRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.track;
    final q = ref.watch(playerProvider);
    final isCurrent = q.current?.id == t.id;
    final titleColor = isCurrent ? Pm.accent : Pm.text;
    // Smart Shuffle recommendation (queue only)
    final rec = widget.queueIndex != null && q.recommended.contains(t.id);
    if (isCompact(context)) return _compact(t, isCurrent, q.playing, rec);

    Widget numberCell;
    if (_hover) {
      numberCell = InkWell(
        onTap: isCurrent
            ? () => ref.read(playerProvider.notifier).togglePlay()
            : widget.onPlay,
        child: Icon(
          isCurrent && q.playing ? Icons.pause : Icons.play_arrow,
          color: Pm.text,
          size: 20,
        ),
      );
    } else if (isCurrent && q.playing) {
      numberCell = const _Equalizer();
    } else {
      numberCell = Text(
        '${widget.number}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isCurrent ? Pm.accent : Pm.subdued,
          fontSize: 15,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onDoubleTap: widget.onPlay,
        onSecondaryTapDown: (d) => showItemMenu(
          context,
          ref,
          t,
          d.globalPosition,
          queueIndex: widget.queueIndex,
          playlistId: widget.playlistId,
        ),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _hover ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              SizedBox(width: 32, child: Center(child: numberCell)),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    if (widget.showCover) ...[
                      Cover(t, size: 40),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              if (rec) ...[
                                Icon(
                                  Icons.auto_awesome,
                                  size: 13,
                                  color: Pm.accent,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Flexible(child: ArtistLinks(t)),
                              if (widget.addedBy != null)
                                Flexible(
                                  child: Text(
                                    '  •  ${context.l10n.widgetTracksAddedBy(widget.addedBy!)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Pm.muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showAlbum)
                Expanded(
                  flex: 3,
                  child: TextLink(
                    t.album ?? '',
                    style: TextStyle(color: Pm.subdued, fontSize: 14),
                    onTap: t.albumId == null
                        ? null
                        : () => context.go('/album/${t.albumId}'),
                  ),
                ),
              if (widget.showDate)
                Expanded(
                  flex: 2,
                  child: Text(
                    _date(context, t.dateCreated),
                    style: TextStyle(color: Pm.subdued, fontSize: 14),
                  ),
                ),
              SizedBox(
                width: 40,
                child: (t.favorite || _hover)
                    ? InkWell(
                        onTap: () => toggleFavorite(context, ref, t),
                        child: Icon(
                          t.favorite
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          size: 18,
                          color: t.favorite ? Pm.accent : Pm.subdued,
                        ),
                      )
                    : null,
              ),
              SizedBox(
                width: 56,
                child: Text(
                  formatDuration(t.duration),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Pm.subdued, fontSize: 14),
                ),
              ),
              SizedBox(
                width: 32,
                child: _hover
                    ? Builder(
                        builder: (bctx) => InkWell(
                          onTapDown: (d) => showItemMenu(
                            context,
                            ref,
                            t,
                            d.globalPosition,
                            queueIndex: widget.queueIndex,
                            playlistId: widget.playlistId,
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Pm.text,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Phone: cover, title/artist and "⋯"; tap plays, long press opens the menu.
  Widget _compact(Item t, bool isCurrent, bool playing, bool rec) {
    return InkWell(
      onTap: isCurrent
          ? () => ref.read(playerProvider.notifier).togglePlay()
          : widget.onPlay,
      onLongPress: () => showItemMenu(
        context,
        ref,
        t,
        Offset.zero,
        queueIndex: widget.queueIndex,
        playlistId: widget.playlistId,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (widget.showCover) ...[
              Cover(t, size: 48),
              const SizedBox(width: 12),
            ] else ...[
              SizedBox(
                width: 28,
                child: isCurrent && playing
                    ? const _Equalizer()
                    : Text(
                        '${widget.number}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCurrent ? Pm.accent : Pm.subdued,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent ? Pm.accent : Pm.text,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (t.favorite) ...[
                        Icon(Icons.check_circle, size: 13, color: Pm.accent),
                        const SizedBox(width: 4),
                      ],
                      if (rec) ...[
                        Icon(Icons.auto_awesome, size: 13, color: Pm.accent),
                        const SizedBox(width: 4),
                      ],
                      if (t.cloud) const CloudBadge(size: 13),
                      OfflineBadge(t.id, size: 13),
                      Expanded(
                        child: Text(
                          widget.addedBy == null
                              ? t.artistLine
                              : '${t.artistLine}  •  ${context.l10n.widgetTracksAddedBy(widget.addedBy!)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Pm.subdued, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Pm.subdued, size: 20),
              tooltip: context.l10n.widgetTracksMoreOptions,
              onPressed: () => showItemMenu(
                context,
                ref,
                t,
                Offset.zero,
                queueIndex: widget.queueIndex,
                playlistId: widget.playlistId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _date(BuildContext context, DateTime? d) {
    if (d == null) return '';
    return context.l10n.widgetTracksAddedDate(d);
  }
}

/// Animated equalizer of the track that is playing.
class _Equalizer extends StatefulWidget {
  const _Equalizer();
  @override
  State<_Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<_Equalizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) {
      final v = _c.value;
      double h(double phase) =>
          4 + 10 * (0.5 + 0.5 * (((v + phase) * 2 % 2) - 1).abs());
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final p in [0.0, 0.35, 0.7, 0.15])
            Container(
              width: 2.5,
              height: h(p),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: Pm.accent,
            ),
        ],
      );
    },
  );
}
