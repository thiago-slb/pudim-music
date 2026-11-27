import 'dart:math';

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
import 'theme_bits.dart';

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

  /// What a tap plays when the table shows only part of it (one disc of an album): the whole
  /// list, starting at the tapped track. Defaults to [tracks].
  final List<Item>? playTracks;

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
    this.playTracks,
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
                onPlay: () {
                  final all = playTracks ?? tracks;
                  final at = identical(all, tracks)
                      ? i
                      : all.indexWhere((t) => t.id == shown[i].id);
                  ref
                      .read(playerProvider.notifier)
                      .playList(
                        all,
                        start: max(0, at),
                        contextName: contextName,
                        contextRoute: contextRoute,
                      );
                },
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
    final t = Pm.current;
    final retro = t.style == UiStyle.retro;
    final st = TextStyle(
      color: switch (t.style) {
        UiStyle.retro => t.accent,
        UiStyle.glass => Colors.white,
        _ => Pm.subdued,
      },
      fontSize: retro ? 12 : 13.5,
      letterSpacing: retro ? 1.2 : null,
      fontWeight: t.style == UiStyle.glass ? FontWeight.w700 : null,
    );
    // Retro: raised column keys; glass: a glossy table header; others a hairline.
    final Decoration deco = switch (t.style) {
      UiStyle.retro => bevel(),
      UiStyle.glass => glass(
        radius: BorderRadius.circular(6),
      ).copyWith(boxShadow: const []),
      UiStyle.ruby => const BoxDecoration(),
      _ => const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
    };
    return Container(
      height: retro ? 28 : 36,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: deco,
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('#', style: st, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Text(
              retro
                  ? context.l10n.widgetTracksTitle.toUpperCase()
                  : context.l10n.widgetTracksTitle,
              style: st,
            ),
          ),
          if (showAlbum)
            Expanded(
              flex: 3,
              child: Text(
                retro
                    ? context.l10n.commonAlbum.toUpperCase()
                    : context.l10n.commonAlbum,
                style: st,
              ),
            ),
          if (showDate)
            Expanded(
              flex: 2,
              child: Text(context.l10n.widgetTracksDateAdded, style: st),
            ),
          const SizedBox(width: 40),
          SizedBox(
            width: 56,
            child: Icon(Icons.schedule, size: 16, color: st.color),
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
  /// Retro: one line of monospace text per track, like a text playlist.
  /// Glass: table rows with columns (number, title, artist, time) and zebra stripes.
  Widget _dense(Item t, bool isCurrent, bool retro) {
    final n = widget.number;
    final color = isCurrent ? Pm.accent : (retro ? Pm.text : Pm.text);
    void menu() => showItemMenu(
      context,
      ref,
      t,
      Offset.zero,
      queueIndex: widget.queueIndex,
      playlistId: widget.playlistId,
    );
    final time = t.duration > Duration.zero ? formatDuration(t.duration) : '';
    if (retro) {
      return InkWell(
        onTap: isCurrent
            ? () => ref.read(playerProvider.notifier).togglePlay()
            : widget.onPlay,
        onLongPress: menu,
        child: Container(
          height: 30,
          color: isCurrent ? Pm.accent.withValues(alpha: 0.15) : null,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${n.toString().padLeft(2, '0')}. ${t.artistLine} - ${t.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Text(time, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      );
    }
    return InkWell(
      onTap: isCurrent
          ? () => ref.read(playerProvider.notifier).togglePlay()
          : widget.onPlay,
      onLongPress: menu,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: n.isOdd
              ? Colors.transparent
              : Pm.elevated.withValues(alpha: 0.6),
          border: Border(
            bottom: BorderSide(color: Pm.highlight.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '$n',
                style: TextStyle(
                  color: isCurrent ? Pm.accent : Pm.muted,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                t.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  shadows: isCurrent
                      ? [Shadow(color: Pm.accent, blurRadius: 8)]
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: Text(
                t.artistLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Pm.subdued, fontSize: 12.5),
              ),
            ),
            SizedBox(
              width: 44,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: TextStyle(color: Pm.subdued, fontSize: 12.5),
              ),
            ),
            GestureDetector(
              onTap: menu,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(Icons.more_vert, color: Pm.muted, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compact(Item t, bool isCurrent, bool playing, bool rec) {
    final style = Pm.current.style;
    if (style == UiStyle.retro || style == UiStyle.glass) {
      return _dense(t, isCurrent, style == UiStyle.retro);
    }
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
              Cover(
                t,
                size: Pm.current.style == UiStyle.ruby ? 56 : 48,
                radius: Pm.current.coverRadius,
              ),
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
