import 'package:material_ui/material_ui.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../audio/player.dart';
import '../../features/lyrics/lyrics_page.dart';
import '../colors.dart';
import '../shell/right_panel.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import 'mobile_shell.dart';
import 'retro_playing.dart';
import '../widgets/theme_bits.dart';
import '../widgets/visual_screen.dart';
import '../../features/jam/jam_sheet.dart';
import '../../features/playlist/playlist_edit.dart';
import '../widgets/sleep_speed.dart';
import '../widgets/cast_button.dart';

/// Phone "Now Playing": background in the cover color, large cover, controls,
/// and below the lyrics, artist and "Up next" cards.
class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    if (cur == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && context.canPop()) context.pop();
      });
      return Scaffold(backgroundColor: Pm.base);
    }
    final style = Pm.current.style;
    if (style == UiStyle.retro) return const RetroNowPlaying();
    final color = currentCoverColor(ref, cur);
    final c = ref.read(playerProvider.notifier);
    final hero = Pm.current.hero;
    // Background: cover color (night), pure black (ruby) or the theme gradient (wave, glass).
    final bg = style == UiStyle.ruby
        ? BoxDecoration(color: Pm.black)
        : hero != null
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: hero,
            ),
          )
        : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darken(color, 0.05), darken(color, 0.45), Pm.base],
              stops: const [0, 0.55, 0.9],
            ),
          );
    final wave = style == UiStyle.wave;
    final glassy = style == UiStyle.glass;
    return Scaffold(
      backgroundColor: Pm.base,
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 400) context.pop();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: bg,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                // The first "screen" takes the full height; the cards come as you scroll.
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    SizedBox(
                      height: box.maxHeight,
                      child: Column(
                        children: [
                          _TopRow(
                            contextName: q.contextName,
                            route: q.contextRoute,
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: LayoutBuilder(
                                  builder: (_, b) => Container(
                                    decoration: wave || glassy
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Pm.current.coverRadius,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    (glassy
                                                            ? Pm.accent
                                                            : Colors.black)
                                                        .withValues(alpha: 0.5),
                                                blurRadius: 30,
                                              ),
                                            ],
                                          )
                                        : null,
                                    child: Cover(
                                      cur,
                                      size: b.maxWidth,
                                      radius: Pm.current.coverRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (glassy) ...[
                            const SizedBox(height: 12),
                            const VisualPanel(),
                          ],
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cur.name,
                                      maxLines: wave ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: wave ? 28 : 22,
                                        height: wave ? 1.1 : null,
                                        fontWeight: wave
                                            ? FontWeight.w900
                                            : FontWeight.w800,
                                        letterSpacing: wave ? -0.5 : null,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      cur.artistLine,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                iconSize: 28,
                                icon: Icon(
                                  cur.favorite
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: cur.favorite ? Pm.accent : Pm.text,
                                ),
                                onPressed: () =>
                                    toggleFavorite(context, ref, cur),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const _Seek(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                iconSize: 26,
                                icon: Icon(
                                  q.smart ? Icons.auto_awesome : Icons.shuffle,
                                  color: q.shuffle ? Pm.accent : Pm.text,
                                ),
                                onPressed: c.toggleShuffle,
                              ),
                              IconButton(
                                iconSize: 44,
                                icon: Icon(
                                  Icons.skip_previous_rounded,
                                  color: Pm.text,
                                ),
                                onPressed: c.previous,
                              ),
                              ThemedPlayButton(
                                size: 68,
                                light: !wave,
                                playing: q.playing,
                                busy: q.buffering,
                                onPressed: c.togglePlay,
                              ),
                              IconButton(
                                iconSize: 44,
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  color: Pm.text,
                                ),
                                onPressed: c.next,
                              ),
                              IconButton(
                                iconSize: 26,
                                icon: Icon(
                                  q.repeat == RepeatMode.one
                                      ? Icons.repeat_one
                                      : Icons.repeat,
                                  color: q.repeat == RepeatMode.off
                                      ? Pm.text
                                      : Pm.accent,
                                ),
                                onPressed: c.cycleRepeat,
                              ),
                            ],
                          ),
                          if (q.recommended.contains(cur.id))
                            RecommendationBar(cur),
                          Row(
                            children: [
                              const JamButton(size: 24),
                              const CastButton(size: 24),
                              const SleepTimerButton(size: 24),
                              const SpeedButton(),
                              const Spacer(),
                              IconButton(
                                tooltip: context.l10n.commonQueue,
                                icon: Icon(Icons.queue_music, color: Pm.text),
                                onPressed: () => context.push('/queue'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    LyricsPreview(cur),
                    const SizedBox(height: 16),
                    if (cur.mainArtist != null)
                      AboutArtistCard(cur.mainArtist!),
                    const SizedBox(height: 16),
                    if (q.next != null) NextUpCard(q.next!),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends ConsumerWidget {
  final String contextName;
  final String? route;
  const _TopRow({required this.contextName, required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(playerProvider).current!;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Pm.text, size: 32),
          tooltip: context.l10n.commonClose,
          onPressed: () => context.pop(),
        ),
        Expanded(
          child: GestureDetector(
            onTap: route == null
                ? null
                : () {
                    final r = GoRouter.of(context);
                    r.pop();
                    r.go(route!);
                  },
            child: Column(
              children: [
                Text(
                  context.l10n.nowPlayingPlayingFrom,
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  contextName.isEmpty ? context.l10n.commonQueue : contextName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Builder(
          builder: (bctx) => IconButton(
            icon: Icon(Icons.more_vert, color: Pm.text),
            tooltip: context.l10n.nowPlayingMoreOptions,
            onPressed: () => showItemMenu(context, ref, cur, Offset.zero),
          ),
        ),
      ],
    );
  }
}

class _Seek extends ConsumerStatefulWidget {
  const _Seek();
  @override
  ConsumerState<_Seek> createState() => _SeekState();
}

class _SeekState extends ConsumerState<_Seek> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final cur = ref.watch(playerProvider).current;
    final dur =
        ref.watch(durationProvider).value ?? cur?.duration ?? Duration.zero;
    final total = dur.inMilliseconds.toDouble();
    final v =
        _drag ??
        (total <= 0 ? 0.0 : (pos.inMilliseconds / total).clamp(0.0, 1.0));
    final shown = _drag != null
        ? Duration(milliseconds: (_drag! * total).round())
        : pos;
    const st = TextStyle(color: Colors.white70, fontSize: 12);
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: Pm.current.style == UiStyle.ruby ? 2 : 3,
            inactiveTrackColor: Colors.white24,
            activeTrackColor: Pm.current.style == UiStyle.night
                ? Pm.text
                : Pm.accent,
            thumbColor: Pm.current.style == UiStyle.night ? Pm.text : Pm.accent,
          ),
          child: SizedBox(
            height: 24,
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
        ),
        Row(
          children: [
            Text(formatDuration(shown), style: st),
            const Spacer(),
            Text(
              '-${formatDuration(dur - shown < Duration.zero ? Duration.zero : dur - shown)}',
              style: st,
            ),
          ],
        ),
      ],
    );
  }
}

/// Full-screen lyrics on the phone (over the cover color), with play below.
class LyricsFullPage extends ConsumerWidget {
  const LyricsFullPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    final color = cur == null ? fallbackColor : currentCoverColor(ref, cur);
    return Scaffold(
      backgroundColor: darken(color, 0.15),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Pm.text,
                    size: 32,
                  ),
                  tooltip: context.l10n.commonClose,
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        cur?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        cur?.artistLine ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const Expanded(child: LyricsPage()),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                children: [
                  const _Seek(),
                  IconButton(
                    iconSize: 56,
                    icon: Icon(
                      q.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Pm.text,
                    ),
                    onPressed: ref.read(playerProvider.notifier).togglePlay,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen queue on the phone.
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Pm.base,
    body: SafeArea(child: QueueView()),
  );
}
