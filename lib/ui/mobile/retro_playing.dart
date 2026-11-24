import 'package:material_ui/material_ui.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/theme_bits.dart';

/// "Now Playing" for the Retrô theme: a compact window with a green LCD (big time, level bars,
/// scrolling title), small transport keys and the queue as a text playlist.
class RetroNowPlaying extends ConsumerWidget {
  const RetroNowPlaying({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current!;
    final c = ref.read(playerProvider.notifier);
    final lcd = TextStyle(color: Pm.accent);
    return Scaffold(
      backgroundColor: Pm.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: bevel(color: Pm.base),
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title bar.
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Pm.highlight, Pm.elevated, Pm.highlight],
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          (q.contextName.isEmpty
                                  ? context.l10n.commonQueue
                                  : q.contextName)
                              .toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.5,
                            color: Pm.subdued,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            showItemMenu(context, ref, cur, Offset.zero),
                        child: Icon(Icons.more_horiz, size: 18, color: Pm.text),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: bevel(),
                          child: Icon(Icons.close, size: 12, color: Pm.text),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // LCD.
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    border: Border.all(
                      color: const Color(0xFF111116),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            q.playing ? Icons.play_arrow : Icons.pause,
                            color: Pm.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          const _BigTime(),
                          const Spacer(),
                          LevelBars(playing: q.playing, height: 34),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Marquee(
                        '${cur.artistLine} - ${cur.name}',
                        style: lcd.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (cur.album != null) cur.album!,
                          if (cur.year != null) '${cur.year}',
                        ].join('  ·  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: lcd.copyWith(
                          fontSize: 11,
                          color: Pm.accent.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const _RetroSeek(),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RetroKey(Icons.skip_previous, onPressed: c.previous),
                    const SizedBox(width: 3),
                    RetroKey(
                      Icons.play_arrow,
                      on: q.playing,
                      onPressed: q.playing ? null : c.togglePlay,
                    ),
                    const SizedBox(width: 3),
                    RetroKey(
                      Icons.pause,
                      on: !q.playing,
                      onPressed: q.playing ? c.togglePlay : null,
                    ),
                    const SizedBox(width: 3),
                    RetroKey(
                      Icons.stop,
                      onPressed: () async {
                        await c.pause();
                        await c.seek(Duration.zero);
                      },
                    ),
                    const SizedBox(width: 3),
                    RetroKey(Icons.skip_next, onPressed: c.next),
                    const Spacer(),
                    RetroKey(
                      Icons.shuffle,
                      on: q.shuffle,
                      onPressed: c.toggleShuffle,
                    ),
                    const SizedBox(width: 3),
                    RetroKey(
                      q.repeat == RepeatMode.one
                          ? Icons.repeat_one
                          : Icons.repeat,
                      on: q.repeat != RepeatMode.off,
                      onPressed: c.cycleRepeat,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Text playlist.
                Expanded(
                  child: Container(
                    decoration: bevel(
                      color: const Color(0xFF000000),
                      pressed: true,
                    ),
                    child: _Playlist(q: q),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BigTime extends ConsumerWidget {
  const _BigTime();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    return Text(
      formatDuration(pos),
      style: TextStyle(
        color: Pm.accent,
        fontSize: 34,
        height: 1,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _RetroSeek extends ConsumerStatefulWidget {
  const _RetroSeek();
  @override
  ConsumerState<_RetroSeek> createState() => _RetroSeekState();
}

class _RetroSeekState extends ConsumerState<_RetroSeek> {
  double? _drag;
  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final dur = ref.watch(durationProvider).value ?? Duration.zero;
    final total = dur.inMilliseconds.toDouble();
    final v =
        _drag ??
        (total <= 0 ? 0.0 : (pos.inMilliseconds / total).clamp(0.0, 1.0));
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        trackShape: const RectangularSliderTrackShape(),
        activeTrackColor: Pm.accent.withValues(alpha: 0.5),
        inactiveTrackColor: const Color(0xFF000000),
        thumbShape: const _BlockThumb(),
        thumbColor: Pm.highlight,
      ),
      child: SizedBox(
        height: 22,
        child: Slider(
          value: v,
          onChanged: (x) => setState(() => _drag = x),
          onChangeEnd: (x) {
            ref
                .read(playerProvider.notifier)
                .seek(Duration(milliseconds: (x * total).round()));
            setState(() => _drag = null);
          },
        ),
      ),
    );
  }
}

/// Rectangular raised slider knob.
class _BlockThumb extends SliderComponentShape {
  const _BlockThumb();
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(22, 14);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final c = context.canvas;
    final r = Rect.fromCenter(center: center, width: 22, height: 14);
    c.drawRect(r, Paint()..color = sliderTheme.thumbColor ?? Colors.grey);
    final light = Paint()..color = const Color(0xFF8A8A98);
    final dark = Paint()..color = const Color(0xFF0E0E12);
    c.drawRect(Rect.fromLTWH(r.left, r.top, r.width, 2), light);
    c.drawRect(Rect.fromLTWH(r.left, r.top, 2, r.height), light);
    c.drawRect(Rect.fromLTWH(r.left, r.bottom - 2, r.width, 2), dark);
    c.drawRect(Rect.fromLTWH(r.right - 2, r.top, 2, r.height), dark);
  }
}

class _Playlist extends ConsumerWidget {
  final QueueState q;
  const _Playlist({required this.q});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ScrollController(
      initialScrollOffset: (q.index - 3).clamp(0, 1 << 20) * 22.0,
    );
    return ListView.builder(
      controller: ctrl,
      itemExtent: 22,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: q.queue.length,
      itemBuilder: (_, i) {
        final t = q.queue[i];
        final on = i == q.index;
        return GestureDetector(
          onTap: () => ref.read(playerProvider.notifier).jumpTo(i),
          child: Container(
            color: on ? Pm.accent.withValues(alpha: 0.18) : null,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${i + 1}. ${t.artistLine} - ${t.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: on ? Colors.white : Pm.accent,
                    ),
                  ),
                ),
                if (t.duration > Duration.zero)
                  Text(
                    formatDuration(t.duration),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: on ? Colors.white : Pm.accent,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
