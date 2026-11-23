import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../audio/player.dart';
import '../../state/ui.dart';
import '../theme.dart';
import 'library_sidebar.dart';
import 'player_bar.dart';
import 'right_panel.dart';
import 'top_bar.dart';
import '../widgets/offline_banner.dart';
import '../widgets/update_banner.dart';
import '../../state/prefetch.dart';

/// Spotify layout: top bar, three columns and the player at the bottom.
class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      prefetchProvider,
    ); // stores the library on the device in the background
    final loc = GoRouterState.of(context).uri.path;
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final panel = ref.watch(rightPanelProvider);
    final hasTrack = ref.watch(playerProvider.select((q) => q.current != null));
    final width = MediaQuery.sizeOf(context).width;
    final showPanel =
        panel != RightPanel.none &&
        loc != '/lyrics' &&
        width > 1000 &&
        (hasTrack || panel == RightPanel.queue);
    final sidebarW = collapsed ? 72.0 : (width > 1400 ? 340.0 : 280.0);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () {
          // Space only when no text field has focus.
          final f = FocusManager.instance.primaryFocus?.context?.widget;
          if (f is EditableText) return;
          ref.read(playerProvider.notifier).togglePlay();
        },
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            context.go('/search'),
        const SingleActivator(
          LogicalKeyboardKey.arrowRight,
          control: true,
        ): () =>
            ref.read(playerProvider.notifier).next(),
        const SingleActivator(
          LogicalKeyboardKey.arrowLeft,
          control: true,
        ): () =>
            ref.read(playerProvider.notifier).previous(),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Pm.black,
          body: Column(
            children: [
              const TopBar(),
              const OfflineBanner(),
              const UpdateBanner(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: sidebarW,
                        child: const _Panel(child: LibrarySidebar()),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _Panel(child: child)),
                      if (showPanel) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 340,
                          child: _Panel(child: RightPanelView()),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 72 + 8, child: PlayerBar()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  const _Panel({required this.child});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: ColoredBox(color: Pm.base, child: child),
  );
}
