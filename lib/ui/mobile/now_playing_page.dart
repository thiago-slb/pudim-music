import 'package:material_ui/material_ui.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../audio/player.dart';
import '../../features/lyrics/lyrics_page.dart';
import '../colors.dart';
import '../shell/right_panel.dart';
import '../theme.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import 'mobile_shell.dart';
import '../../features/jam/jam_sheet.dart';
import '../../features/playlist/playlist_edit.dart';
import '../widgets/sleep_speed.dart';

/// "Tocando agora" do celular: fundo na cor da capa, capa grande, controles,
/// e abaixo os cartões de letra, artista e "A seguir".
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
      return const Scaffold(backgroundColor: Pm.base);
    }
    final color = currentCoverColor(ref, cur);
    final c = ref.read(playerProvider.notifier);
    return Scaffold(
      backgroundColor: Pm.base,
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 400) context.pop();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darken(color, 0.05), darken(color, 0.45), Pm.base],
              stops: const [0, 0.55, 0.9],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                // A primeira "tela" ocupa a altura toda; os cartões vêm ao rolar.
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
                                  builder: (_, b) =>
                                      Cover(cur, size: b.maxWidth, radius: 8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cur.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
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
                                  color: cur.favorite ? Pm.green : Pm.text,
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
                                  color: q.shuffle ? Pm.green : Pm.text,
                                ),
                                onPressed: c.toggleShuffle,
                              ),
                              IconButton(
                                iconSize: 44,
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: Pm.text,
                                ),
                                onPressed: c.previous,
                              ),
                              Material(
                                color: Pm.text,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: c.togglePlay,
                                  child: SizedBox(
                                    width: 68,
                                    height: 68,
                                    child: q.buffering
                                        ? const Padding(
                                            padding: EdgeInsets.all(22),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Icon(
                                            q.playing
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.black,
                                            size: 42,
                                          ),
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 44,
                                icon: const Icon(
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
                                      : Pm.green,
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
                              const SleepTimerButton(size: 24),
                              const SpeedButton(),
                              const Spacer(),
                              IconButton(
                                tooltip: 'Fila',
                                icon: const Icon(
                                  Icons.queue_music,
                                  color: Pm.text,
                                ),
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
          icon: const Icon(Icons.keyboard_arrow_down, color: Pm.text, size: 32),
          tooltip: 'Fechar',
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
                const Text(
                  'TOCANDO DE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  contextName.isEmpty ? 'Fila' : contextName,
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
            icon: const Icon(Icons.more_vert, color: Pm.text),
            tooltip: 'Mais opções',
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
          data: SliderTheme.of(context)
              .copyWith(trackHeight: 3, inactiveTrackColor: Colors.white24),
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

/// Letra em tela cheia no celular (sobre a cor da capa), com play embaixo.
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
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Pm.text,
                    size: 32,
                  ),
                  tooltip: 'Fechar',
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

/// Fila em tela cheia no celular.
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Pm.base,
    body: SafeArea(child: QueueView()),
  );
}
