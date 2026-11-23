import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/session.dart';
import '../colors.dart';
import '../theme.dart';
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
    if (_stack.length > 1) context.go(_stack[_stack.length - 2]);
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
                          icon: const Icon(Icons.arrow_back, color: Pm.text),
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
        bottomNavigationBar: _NavBar(
          index: tab,
          tabs: _tabs,
          onTap: (i) => _openTab(_tabs[i]),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int index;
  final List<String> tabs;
  final ValueChanged<int> onTap;
  const _NavBar({required this.index, required this.tabs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget item(int i, IconData icon, IconData selIcon, String label) {
      final sel = i == index;
      return Expanded(
        child: InkResponse(
          onTap: () => onTap(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                sel ? selIcon : icon,
                color: sel ? Pm.text : Pm.subdued,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: sel ? Pm.text : Pm.subdued,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xE6000000), Pm.black],
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      height: 64 + MediaQuery.paddingOf(context).bottom,
      child: Row(
        children: [
          item(0, Icons.home_outlined, Icons.home_filled, l10n.commonHome),
          item(1, Icons.search, Icons.manage_search, l10n.commonSearch),
          if (tabs.contains('/shows'))
            item(2, Icons.event_outlined, Icons.event, l10n.commonShows),
          item(
            tabs.indexOf('/library'),
            Icons.library_music_outlined,
            Icons.library_music,
            l10n.commonYourLibrary,
          ),
        ],
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

/// Mini player above the bar: tap or drag up opens Now Playing.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(playerProvider);
    final cur = q.current;
    if (cur == null) return const SizedBox.shrink();
    final c = ref.read(playerProvider.notifier);
    final bg = darken(currentCoverColor(ref, cur), 0.2);
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        height: 58,
        decoration: BoxDecoration(
          color: bg,
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cur.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          cur.artistLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      cur.favorite
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: cur.favorite ? Pm.green : Pm.text,
                    ),
                    tooltip: cur.favorite
                        ? context.l10n.commonRemoveFromLiked
                        : context.l10n.commonAddToLiked,
                    onPressed: () => toggleFavorite(context, ref, cur),
                  ),
                  IconButton(
                    icon: q.buffering
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Pm.text,
                            ),
                          )
                        : Icon(
                            q.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Pm.text,
                            size: 32,
                          ),
                    tooltip: q.playing
                        ? context.l10n.commonPause
                        : context.l10n.playerBarPlay,
                    onPressed: c.togglePlay,
                  ),
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
    );
  }
}

class _MiniProgress extends ConsumerWidget {
  const _MiniProgress();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final dur = ref.watch(durationProvider).value ?? Duration.zero;
    final v = dur.inMilliseconds <= 0
        ? 0.0
        : (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(1),
      child: LinearProgressIndicator(
        value: v,
        minHeight: 2,
        color: Pm.text,
        backgroundColor: Colors.white24,
      ),
    );
  }
}
