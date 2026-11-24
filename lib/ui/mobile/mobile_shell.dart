import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/scroll_memory.dart';

import '../../l10n/l10n.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/session.dart';
import '../colors.dart';
import '../theme.dart';
import '../widgets/theme_bits.dart';
import '../widgets/actions.dart';
import '../widgets/common.dart';
import '../widgets/offline_banner.dart';
import '../widgets/update_banner.dart';
import '../../state/prefetch.dart';

/// Phone layout: full-screen page, mini player and the bottom bar
/// Home · Search · Shows · Your Library.
class MobileShell extends ConsumerStatefulWidget {
  final Widget child;
  const MobileShell({super.key, required this.child});
  @override
  ConsumerState<MobileShell> createState() => _MobileShellState();
}

const _allTabs = ['/', '/search', '/shows', '/library'];
const _baseTabs = ['/', '/search', '/library'];

class _MobileShellState extends ConsumerState<MobileShell> {
  /// Own history: the app navigates with `go`, so the Android back button
  /// needs to know where we came from.
  final _stack = <String>[];

  static String _key(String loc) {
    final path = Uri.parse(loc).path;
    return path == '/search' ? '/search' : loc;
  }

  void _track(String loc) {
    final key = _key(loc);
    if (_stack.isNotEmpty && _key(_stack.last) == key) {
      _stack[_stack.length - 1] = loc;
    } else if (_stack.length >= 2 && _key(_stack[_stack.length - 2]) == key) {
      _stack.removeLast();
      _stack[_stack.length - 1] = loc;
    } else {
      _stack.add(loc);
      if (_stack.length > 50) _stack.removeAt(0);
    }
  }

  void _back() {
    if (_stack.length < 2) return;
    final prev = _stack[_stack.length - 2];
    ScrollMemory.markBack(prev);
    context.go(prev);
  }

  void _openTab(String tab) {
    _stack
      ..clear()
      ..addAll(tab == '/' ? ['/'] : ['/', tab]);
    context.go(tab);
  }

  List<String> _tabs = _allTabs;

  @override
  Widget build(BuildContext context) {
    _tabs = ref.watch(hasExtrasProvider) ? _allTabs : _baseTabs;
    ref.watch(
      prefetchProvider,
    ); // stores the library on the device in the background
    final uri = GoRouterState.of(context).uri;
    _track(uri.toString());
    final path = uri.path;
    final isRoot = _tabs.contains(path) || path == '/settings';
    var tab = 0;
    for (final l in _stack.reversed) {
      final i = _tabs.indexOf(Uri.parse(l).path);
      if (i >= 0) {
        tab = i;
        break;
      }
    }
    return PopScope(
      canPop: _stack.length <= 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: Pm.base,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SafeArea(bottom: false, child: widget.child),
                  ),
                  if (!isRoot || path == '/settings')
                    Positioned(
                      top: MediaQuery.paddingOf(context).top + 8,
                      left: 8,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Pm.text),
                          tooltip: context.l10n.commonBack,
                          onPressed: () =>
                              _stack.length > 1 ? _back() : context.go('/'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const OfflineBanner(),
            const UpdateBanner(),
            const MiniPlayer(),
          ],
        ),
        // Every theme keeps the tabs at the bottom (retro moved them to a thin top strip that
        // read as a title bar, so they looked gone).
        bottomNavigationBar: MobileNavBar(
          index: tab,
          tabs: _tabs,
          onTap: (i) => _openTab(_tabs[i]),
        ),
      ),
    );
  }
}

/// Main tabs of the phone app (Home, Search, Shows, Library) in the theme's style.
class MobileNavBar extends StatelessWidget {
  final int index;
  final List<String> tabs;
  final ValueChanged<int> onTap;
  const MobileNavBar({
    super.key,
    required this.index,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <(int, IconData, IconData, String)>[
      (0, Icons.home_outlined, Icons.home_filled, l10n.commonHome),
      (1, Icons.search, Icons.manage_search, l10n.commonSearch),
      if (tabs.contains('/shows'))
        (2, Icons.event_outlined, Icons.event, l10n.commonShows),
      (
        tabs.indexOf('/library'),
        Icons.library_music_outlined,
        Icons.library_music,
        l10n.commonYourLibrary,
      ),
    ];
    final style = Pm.current.style;
    final safe = MediaQuery.paddingOf(context).bottom;
    if (style == UiStyle.retro) {
      // Raised gray panel with a row of bevel keys; the open tab is pressed in, with an
      // LCD-green label.
      return Container(
        decoration: bevel(color: Pm.highlight),
        padding: EdgeInsets.fromLTRB(6, 6, 6, 6 + safe),
        child: Row(
          children: [
            for (final (i, icon, selIcon, label) in items)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Container(
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: bevel(
                      pressed: i == index,
                      color: i == index ? Colors.black : Pm.elevated,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          i == index ? selIcon : icon,
                          size: 18,
                          color: i == index ? Pm.accent : Pm.text,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            color: i == index ? Pm.accent : Pm.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget item(int i, IconData icon, IconData selIcon, String label) {
      final sel = i == index;
      final color = sel
          ? (style == UiStyle.glass ? Pm.accent : Pm.text)
          : Pm.subdued;
      Widget ic = Icon(sel ? selIcon : icon, color: color, size: 26);
      if (style == UiStyle.wave && sel) {
        // Highlighted pill behind the selected tab.
        ic = Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(
            color: Pm.accent.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ic,
        );
      } else if (style == UiStyle.glass && sel) {
        ic = Icon(
          selIcon,
          color: color,
          size: 26,
          shadows: [Shadow(color: Pm.accent, blurRadius: 12)],
        );
      }
      return Expanded(
        child: InkResponse(
          onTap: () => onTap(i),
          // Shrinks to fit the 64 px bar: the Wave highlight pill plus a large system font made
          // the selected tab taller than the bar.
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ic,
                  const SizedBox(height: 4),
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: sel
                          ? (style == UiStyle.wave
                                ? FontWeight.w800
                                : FontWeight.w600)
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final decoration = switch (style) {
      UiStyle.ruby => BoxDecoration(
        color: Pm.black,
        border: Border(top: BorderSide(color: Pm.highlight)),
      ),
      UiStyle.glass => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Pm.highlight, Pm.black],
        ),
        border: Border(
          top: BorderSide(color: Pm.accent.withValues(alpha: 0.6)),
        ),
      ),
      UiStyle.wave => BoxDecoration(color: Pm.black),
      _ => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xE6000000), Pm.black],
        ),
      ),
    };
    return Container(
      decoration: decoration,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      height: 64 + MediaQuery.paddingOf(context).bottom,
      child: Row(
        children: [for (final (i, a, b, l) in items) item(i, a, b, l)],
      ),
    );
  }
}

/// Color of the current track cover (for the mini player and Now Playing).
Color currentCoverColor(WidgetRef ref, Item track) {
  final url = ref.watch(apiProvider).imageUrl(track.imageItemId, size: 64);
  if (url == null) return fallbackColor;
  return ref.watch(coverColorProvider(url)).value ?? fallbackColor;
}

/// Mini player above the bar: tap or drag up opens Now Playing. Its shape follows the theme:
/// floating card, flat full-width strip, pill, bevelled LCD panel or glass.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    if (cur == null) return const SizedBox.shrink();
    final c = ref.read(playerProvider.notifier);
    final style = Pm.current.style;
    final l10n = context.l10n;

    Widget playBtn({double size = 32}) => IconButton(
      icon: q.buffering
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Pm.text),
            )
          : Icon(
              q.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Pm.text,
              size: size,
            ),
      tooltip: q.playing ? l10n.commonPause : l10n.playerBarPlay,
      onPressed: c.togglePlay,
    );
    final fav = IconButton(
      icon: Icon(
        cur.favorite ? Icons.check_circle : Icons.add_circle_outline,
        color: cur.favorite ? Pm.accent : Pm.text,
      ),
      tooltip: cur.favorite
          ? l10n.commonRemoveFromLiked
          : l10n.commonAddToLiked,
      onPressed: () => toggleFavorite(context, ref, cur),
    );
    Widget titles({Color? sub, double size = 14, FontWeight? weight}) => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cur.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: size,
            fontWeight: weight ?? FontWeight.w600,
          ),
        ),
        Text(
          cur.artistLine,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: sub ?? Colors.white70, fontSize: 12.5),
        ),
      ],
    );

    final Widget body = switch (style) {
      // Flat strip glued to the bar, progress line on top, square cover.
      UiStyle.ruby => Container(
        color: Pm.elevated,
        height: 64,
        child: Column(
          children: [
            const _MiniProgress(height: 2),
            Expanded(
              child: Row(
                children: [
                  Cover(cur, size: 62, radius: 0),
                  const SizedBox(width: 12),
                  Expanded(child: titles(sub: Pm.subdued)),
                  playBtn(),
                  IconButton(
                    icon: Icon(Icons.skip_next_rounded, color: Pm.text),
                    tooltip: l10n.rightPanelNextUp,
                    onPressed: c.next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating pill with a gradient and a round cover.
      UiStyle.wave => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Pm.accent, Color.lerp(Pm.accent, Pm.black, 0.55)!],
          ),
          boxShadow: [
            BoxShadow(color: Pm.accent.withValues(alpha: 0.35), blurRadius: 16),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 6),
            Cover(cur, size: 48, round: true),
            const SizedBox(width: 12),
            Expanded(child: titles(weight: FontWeight.w800)),
            fav,
            playBtn(),
            const SizedBox(width: 4),
          ],
        ),
      ),
      // Bevelled panel: LCD with scrolling title, level bars and small transport keys.
      UiStyle.retro => Container(
        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        padding: const EdgeInsets.all(6),
        decoration: bevel(),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  border: Border.all(color: const Color(0xFF111116), width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Marquee(
                            '${cur.artistLine} - ${cur.name}',
                            style: TextStyle(color: Pm.accent, fontSize: 13),
                          ),
                          const _MiniTime(),
                        ],
                      ),
                    ),
                    LevelBars(playing: q.playing, height: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            RetroKey(Icons.skip_previous, width: 32, onPressed: c.previous),
            const SizedBox(width: 2),
            RetroKey(
              q.playing ? Icons.pause : Icons.play_arrow,
              width: 36,
              on: q.playing,
              onPressed: c.togglePlay,
            ),
            const SizedBox(width: 2),
            RetroKey(Icons.skip_next, width: 32, onPressed: c.next),
          ],
        ),
      ),
      // Glass capsule with an orb play button.
      UiStyle.glass => Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Pm.press, Pm.elevated, Pm.black],
            stops: const [0, 0.5, 1],
          ),
          border: Border.all(color: Pm.accent.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(color: Pm.accent.withValues(alpha: 0.25), blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Cover(cur, size: 44, radius: Pm.current.coverRadius),
                  const SizedBox(width: 10),
                  Expanded(child: titles(sub: Pm.subdued)),
                  fav,
                  ThemedPlayButton(
                    size: 44,
                    playing: q.playing,
                    busy: q.buffering,
                    onPressed: c.togglePlay,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: _MiniProgress(height: 2),
            ),
            const SizedBox(height: 3),
          ],
        ),
      ),
      // Default: floating card in the cover color.
      UiStyle.night => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        height: 58,
        decoration: BoxDecoration(
          color: darken(currentCoverColor(ref, cur), 0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Cover(cur, size: 40),
                  const SizedBox(width: 10),
                  Expanded(child: titles()),
                  fav,
                  playBtn(),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: _MiniProgress(),
            ),
          ],
        ),
      ),
    };
    return GestureDetector(
      onTap: () => context.push('/playing'),
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) < -200) context.push('/playing');
      },
      onHorizontalDragEnd: (d) {
        final v = d.primaryVelocity ?? 0;
        if (v < -300) c.next();
        if (v > 300) c.previous();
      },
      child: body,
    );
  }
}

class _MiniProgress extends ConsumerWidget {
  final double height;
  const _MiniProgress({this.height = 2});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final dur = ref.watch(durationProvider).value ?? Duration.zero;
    final v = dur.inMilliseconds <= 0
        ? 0.0
        : (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0);
    final style = Pm.current.style;
    return ClipRRect(
      borderRadius: BorderRadius.circular(1),
      child: LinearProgressIndicator(
        value: v,
        minHeight: height,
        color: style == UiStyle.night ? Pm.text : Pm.accent,
        backgroundColor: Colors.white24,
      ),
    );
  }
}

/// Elapsed time in LCD digits (retro mini player).
class _MiniTime extends ConsumerWidget {
  const _MiniTime();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    return Text(
      formatDuration(pos),
      style: TextStyle(
        color: Pm.accent.withValues(alpha: 0.75),
        fontSize: 11,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
