import 'package:material_ui/material_ui.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../audio/player.dart';
import '../../state/ui.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import '../../features/jam/jam_sheet.dart';
import '../widgets/sleep_speed.dart';

/// Barra do player no rodapé: faixa à esquerda, controles no centro, extras à direita.
class PlayerBar extends ConsumerWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    return Container(
      height: 80,
      color: Pm.black,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Esquerda: capa, título, artista, curtir.
          Expanded(
            flex: 3,
            child: cur == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () => ref
                            .read(rightPanelProvider.notifier)
                            .toggle(RightPanel.nowPlaying),
                        child: Cover(cur, size: 56),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextLink(
                              cur.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: cur.albumId == null
                                  ? null
                                  : () => context.go(routeFor(cur)),
                            ),
                            ArtistLinks(
                              cur,
                              style: const TextStyle(
                                color: Pm.subdued,
                                fontSize: 12,
                              ),
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
                        size: 18,
                        onPressed: () => toggleFavorite(context, ref, cur),
                      ),
                    ],
                  ),
          ),
          // Centro: controles + progresso.
          Expanded(flex: 4, child: _Controls(q: q)),
          // Direita.
          Expanded(flex: 3, child: _Extras()),
        ],
      ),
    );
  }
}

class _Controls extends ConsumerWidget {
  final QueueState q;
  const _Controls({required this.q});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(playerProvider.notifier);
    final hasTrack = q.current != null;
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconBtn(
              q.smart ? Icons.auto_awesome : Icons.shuffle,
              tooltip: q.smart
                  ? l10n.playerBarSmartShuffleOff
                  : q.shuffle
                  ? (q.contextPlaylistId != null
                        ? l10n.playerBarSmartShuffleOn
                        : l10n.playerBarShuffleOff)
                  : l10n.playerBarShuffleOn,
              active: q.shuffle,
              size: 18,
              onPressed: c.toggleShuffle,
            ),
            IconBtn(
              Icons.skip_previous_rounded,
              tooltip: l10n.commonBack,
              size: 26,
              onPressed: hasTrack ? c.previous : null,
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: q.playing ? l10n.commonPause : l10n.playerBarPlay,
              child: Material(
                color: Pm.text,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: hasTrack ? c.togglePlay : null,
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: q.buffering
                        ? const Padding(
                            padding: EdgeInsets.all(9),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Icon(
                            q.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconBtn(
              Icons.skip_next_rounded,
              tooltip: l10n.playerBarForward,
              size: 26,
              onPressed: hasTrack ? c.next : null,
            ),
            IconBtn(
              q.repeat == RepeatMode.one ? Icons.repeat_one : Icons.repeat,
              tooltip: switch (q.repeat) {
                RepeatMode.off => l10n.playerBarRepeatOn,
                RepeatMode.all => l10n.playerBarRepeatOne,
                RepeatMode.one => l10n.playerBarRepeatOff,
              },
              active: q.repeat != RepeatMode.off,
              size: 18,
              onPressed: c.cycleRepeat,
            ),
          ],
        ),
        const _Progress(),
      ],
    );
  }
}

class _Progress extends ConsumerStatefulWidget {
  const _Progress();
  @override
  ConsumerState<_Progress> createState() => _ProgressState();
}

class _ProgressState extends ConsumerState<_Progress> {
  double? _dragging;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final cur = ref.watch(playerProvider).current;
    final dur =
        ref.watch(durationProvider).value ?? cur?.duration ?? Duration.zero;
    final total = dur.inMilliseconds.toDouble();
    final value =
        _dragging ??
        (total <= 0 ? 0.0 : (pos.inMilliseconds / total).clamp(0.0, 1.0));
    final shown = _dragging != null
        ? Duration(milliseconds: (_dragging! * total).round())
        : pos;
    const st = TextStyle(color: Pm.subdued, fontSize: 12);
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            formatDuration(shown),
            style: st,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _hover ? Pm.green : Pm.text,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: _hover ? 6 : 0,
                ),
              ),
              child: SizedBox(
                height: 16,
                child: Slider(
                  value: value,
                  onChanged: cur == null
                      ? null
                      : (v) => setState(() => _dragging = v),
                  onChangeEnd: (v) {
                    ref
                        .read(playerProvider.notifier)
                        .seek(Duration(milliseconds: (v * total).round()));
                    setState(() => _dragging = null);
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 44, child: Text(formatDuration(dur), style: st)),
      ],
    );
  }
}

class _Extras extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Extras> createState() => _ExtrasState();
}

class _ExtrasState extends ConsumerState<_Extras> {
  double? _beforeMute;

  @override
  Widget build(BuildContext context) {
    final panel = ref.watch(rightPanelProvider);
    final loc = GoRouterState.of(context).uri.path;
    final vol = ref.watch(volumeProvider).value ?? 0.8;
    final c = ref.read(playerProvider.notifier);
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconBtn(
          Icons.slideshow_outlined,
          tooltip: l10n.playerBarNowPlayingView,
          size: 18,
          active: panel == RightPanel.nowPlaying,
          onPressed: () => ref
              .read(rightPanelProvider.notifier)
              .toggle(RightPanel.nowPlaying),
        ),
        IconBtn(
          Icons.mic_none_rounded,
          tooltip: l10n.playerBarLyrics,
          size: 18,
          active: loc == '/lyrics',
          onPressed: () {
            if (loc == '/lyrics') {
              context.pop();
            } else {
              context.push('/lyrics');
            }
          },
        ),
        const SpeedButton(),
        const SleepTimerButton(),
        const JamButton(),
        IconBtn(
          Icons.queue_music,
          tooltip: l10n.commonQueue,
          size: 18,
          active: panel == RightPanel.queue,
          onPressed: () =>
              ref.read(rightPanelProvider.notifier).toggle(RightPanel.queue),
        ),
        IconBtn(
          vol == 0
              ? Icons.volume_off_outlined
              : vol < 0.5
              ? Icons.volume_down_outlined
              : Icons.volume_up_outlined,
          tooltip: vol == 0 ? l10n.playerBarUnmute : l10n.playerBarMute,
          size: 18,
          onPressed: () {
            if (vol == 0) {
              c.setVolume(_beforeMute ?? 0.8);
            } else {
              _beforeMute = vol;
              c.setVolume(0);
            }
          },
        ),
        SizedBox(
          width: 100,
          child: SizedBox(
            height: 16,
            child: Slider(value: vol, onChanged: c.setVolume),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
