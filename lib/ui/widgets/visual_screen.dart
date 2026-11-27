// window_manager legacy bridge, like the rest of the app (the 0.7 native API is still recent).
// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:material_ui/material_ui.dart' hide RepeatMode;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/legacy.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../features/lyrics/lyrics_data.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../responsive.dart';
import '../theme.dart';
import 'visuals.dart';

/// Visualization picked last (kept between sessions).
final visualKindProvider = NotifierProvider<VisualKindNotifier, VisualKind>(
  VisualKindNotifier.new,
);

class VisualKindNotifier extends Notifier<VisualKind> {
  @override
  VisualKind build() {
    final i = ref.read(prefsProvider).getInt('visualKind') ?? 0;
    return VisualKind.values[i.clamp(0, VisualKind.values.length - 1)];
  }

  void step(int by) {
    final n = VisualKind.values.length;
    state = VisualKind.values[(state.index + by) % n];
    ref.read(prefsProvider).setInt('visualKind', state.index);
  }
}

String visualName(BuildContext context, VisualKind k) => switch (k) {
  VisualKind.waves => context.l10n.visualsWaves,
  VisualKind.swirl => context.l10n.visualsSwirl,
  VisualKind.bars => context.l10n.visualsBars,
  VisualKind.nebula => context.l10n.visualsNebula,
};

/// Opens the visualization full screen.
Future<void> openVisuals(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, _, _) => const VisualScreen(),
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );

/// The small panel on Now Playing: tap opens it full screen.
class VisualPanel extends ConsumerWidget {
  final double height;
  const VisualPanel({super.key, this.height = 96});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final kind = ref.watch(visualKindProvider);
    return Semantics(
      button: true,
      label: context.l10n.visualsFullscreen,
      child: GestureDetector(
        onTap: () => openVisuals(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AmbientVisual(
                  playing: q.playing,
                  kind: kind,
                  seed: q.current?.id ?? '',
                ),
                const Positioned(
                  right: 6,
                  bottom: 6,
                  child: Icon(
                    Icons.fullscreen,
                    size: 20,
                    color: Colors.white70,
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

/// Full screen: the visualization on top, the lyrics passing by at the bottom (when there are
/// any). A tap shows the controls (close, switch, previous / play / next); a swipe switches.
class VisualScreen extends ConsumerStatefulWidget {
  const VisualScreen({super.key});

  @override
  ConsumerState<VisualScreen> createState() => _VisualScreenState();
}

class _VisualScreenState extends ConsumerState<VisualScreen> {
  bool _controls = true;
  Timer? _hide;
  String? _toast;
  Timer? _toastTimer;
  bool _wasFullScreen = false;

  @override
  void initState() {
    super.initState();
    _scheduleHide();
    if (isDesktop) {
      unawaited(() async {
        try {
          _wasFullScreen = await windowManager.isFullScreen();
          await windowManager.setFullScreen(true);
        } catch (_) {}
      }());
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    _hide?.cancel();
    _toastTimer?.cancel();
    if (isDesktop) {
      if (!_wasFullScreen) {
        unawaited(windowManager.setFullScreen(false).catchError((_) {}));
      }
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  void _scheduleHide() {
    _hide?.cancel();
    _hide = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _controls = false);
    });
  }

  void _toggleControls() {
    setState(() => _controls = !_controls);
    if (_controls) _scheduleHide();
  }

  void _switch(int by) {
    ref.read(visualKindProvider.notifier).step(by);
    _toastTimer?.cancel();
    setState(() => _toast = visualName(context, ref.read(visualKindProvider)));
    _toastTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _toast = null);
    });
    if (_controls) _scheduleHide();
  }

  @override
  Widget build(BuildContext context) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    final kind = ref.watch(visualKindProvider);
    final lyrics = cur == null ? null : ref.watch(lyricsProvider(cur.id)).value;
    final hasLyrics = lyrics != null && !lyrics.isEmpty;
    final player = ref.read(playerProvider.notifier);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _switch(1),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _switch(-1),
        const SingleActivator(LogicalKeyboardKey.space): () =>
            unawaited(player.togglePlay()),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, box) {
              // The lyrics take about a quarter of the screen at the bottom.
              final band = hasLyrics
                  ? (box.maxHeight * 0.26).clamp(120.0, 320.0)
                  : 0.0;
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: band,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleControls,
                      onHorizontalDragEnd: (d) {
                        final v = d.primaryVelocity ?? 0;
                        if (v.abs() > 200) _switch(v < 0 ? 1 : -1);
                      },
                      child: AmbientVisual(
                        playing: q.playing,
                        kind: kind,
                        seed: cur?.id ?? '',
                      ),
                    ),
                  ),
                  if (hasLyrics && cur != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: band,
                      child: _LyricsBand(lyrics: lyrics, track: cur),
                    ),
                  // Switch name, shown for a moment.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: box.maxHeight * 0.12,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _toast == null ? 0 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: Center(
                          child: Text(
                            _toast ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(color: Pm.accent, blurRadius: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: band,
                    child: IgnorePointer(
                      ignoring: !_controls,
                      child: AnimatedOpacity(
                        opacity: _controls ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: _Controls(
                          track: cur,
                          playing: q.playing,
                          onClose: () => Navigator.of(context).maybePop(),
                          onSwitch: () => _switch(1),
                          onPrevious: () {
                            unawaited(player.previous());
                            _scheduleHide();
                          },
                          onPlay: () {
                            unawaited(player.togglePlay());
                            _scheduleHide();
                          },
                          onNext: () {
                            unawaited(player.next());
                            _scheduleHide();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final Item? track;
  final bool playing;
  final VoidCallback onClose, onSwitch, onPrevious, onPlay, onNext;
  const _Controls({
    required this.track,
    required this.playing,
    required this.onClose,
    required this.onSwitch,
    required this.onPrevious,
    required this.onPlay,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final t = track;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xAA000000), Colors.transparent, Color(0x88000000)],
          stops: [0, 0.4, 1],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: context.l10n.commonClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onClose,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          t?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          t?.artistLine ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.visualsSwitch,
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                    onPressed: onSwitch,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: onPrevious,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 56,
                    icon: Icon(
                      playing ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                    ),
                    onPressed: onPlay,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: onNext,
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

/// Lyrics passing by at the bottom: synced ones move up line by line with the music; plain ones
/// scroll slowly along with the track.
class _LyricsBand extends ConsumerStatefulWidget {
  final Lyrics lyrics;
  final Item track;
  const _LyricsBand({required this.lyrics, required this.track});

  @override
  ConsumerState<_LyricsBand> createState() => _LyricsBandState();
}

class _LyricsBandState extends ConsumerState<_LyricsBand> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final l = widget.lyrics;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0xCC000000), Colors.black],
          stops: [0, 0.25, 1],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: l.synced ? _synced(l, pos) : _plain(l, pos),
        ),
      ),
    );
  }

  Widget _synced(Lyrics l, Duration pos) {
    final idx = l.indexAt(pos);
    String line(int i) =>
        i >= 0 && i < l.lines.length ? l.lines[i].text.trim() : '';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.25),
            end: Offset.zero,
          ).animate(a),
          child: child,
        ),
      ),
      child: Column(
        key: ValueKey(idx),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _text(line(idx - 1), 0.35, 16),
          const SizedBox(height: 6),
          _text(line(idx), 1, 24, glow: true),
          const SizedBox(height: 6),
          _text(line(idx + 1), 0.5, 17),
          _text(line(idx + 2), 0.25, 15),
        ],
      ),
    );
  }

  Widget _plain(Lyrics l, Duration pos) {
    // Scrolls along with the track: the end of the text at the end of the song.
    final dur =
        ref.read(playerProvider.notifier).duration ?? widget.track.duration;
    final f = dur.inMilliseconds <= 0
        ? 0.0
        : (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent * f);
      }
    });
    return ShaderMask(
      shaderCallback: (r) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: [0, 0.2, 0.8, 1],
      ).createShader(r),
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        controller: _scroll,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [for (final x in l.lines) _text(x.text.trim(), 0.85, 18)],
        ),
      ),
    );
  }

  Widget _text(String s, double alpha, double size, {bool glow = false}) =>
      Text(
        s,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withValues(alpha: alpha),
          fontSize: size,
          height: 1.3,
          fontWeight: glow ? FontWeight.w800 : FontWeight.w600,
          shadows: glow ? [Shadow(color: Pm.accent, blurRadius: 16)] : null,
        ),
      );
}
