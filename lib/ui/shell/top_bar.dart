// The new API (nativeapi) of window_manager 0.7 is still recent; we use the legacy bridge.
// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/legacy.dart';

import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../theme.dart';
import '../widgets/accounts.dart';
import '../widgets/downloads_bell.dart';
import '../widgets/common.dart';
import '../../features/chat/chat_pages.dart';
import '../widgets/user_photo.dart';
import '../widgets/themed.dart';

/// Top bar: menu, back/forward, Home, pill search, avatar and window buttons.
class TopBar extends ConsumerStatefulWidget {
  const TopBar({super.key});
  @override
  ConsumerState<TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<TopBar> {
  final _search = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = v.trim();
      if (!mounted) return;
      context.go(
        q.isEmpty ? '/search' : '/search?q=${Uri.encodeQueryComponent(q)}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sb = searchBox(focused: _focus.hasFocus, phone: false);
    final path = GoRouterState.of(context).uri.path;
    final q = GoRouterState.of(context).uri.queryParameters['q'] ?? '';
    if (path == '/search' && _search.text != q && !_focus.hasFocus) {
      _search.text = q;
    }
    if (path != '/search' && _search.text.isNotEmpty && !_focus.hasFocus) {
      _search.clear();
    }
    final session = ref.watch(sessionProvider).value;
    return DragToMoveArea(
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            // macOS keeps its own traffic lights on the left.
            SizedBox(width: Platform.isMacOS ? 84 : 12),
            _AppMenu(),
            IconBtn(
              Icons.chevron_left,
              tooltip: context.l10n.commonBack,
              size: 28,
              onPressed: context.canPop() ? () => context.pop() : null,
            ),
            const Spacer(),
            Tooltip(
              message: context.l10n.commonHome,
              child: Material(
                color: Pm.elevated,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.go('/'),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      path == '/' ? Icons.home_filled : Icons.home_outlined,
                      color: path == '/' ? Pm.text : Pm.subdued,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, minWidth: 260),
              child: Container(
                height: 48,
                decoration: sb.box,
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: sb.hint, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Focus(
                        onFocusChange: (_) => setState(() {}),
                        child: TextField(
                          controller: _search,
                          focusNode: _focus,
                          onChanged: _onChanged,
                          onTap: () {
                            if (path != '/search') context.go('/search');
                          },
                          style: TextStyle(fontSize: 16, color: sb.text),
                          cursorColor: sb.text,
                          decoration: InputDecoration(
                            hintText: context.l10n.topBarSearchHint,
                            hintStyle: TextStyle(color: sb.hint),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    if (_search.text.isNotEmpty)
                      IconBtn(
                        Icons.close,
                        tooltip: context.l10n.topBarClearSearch,
                        onPressed: () {
                          _search.clear();
                          context.go('/search');
                        },
                      ),
                    Container(width: 1, height: 24, color: Pm.muted),
                    IconBtn(
                      Icons.grid_view_rounded,
                      tooltip: context.l10n.topBarBrowse,
                      size: 22,
                      active: path == '/search' && q.isEmpty,
                      onPressed: () => context.go('/search'),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (ref.watch(hasExtrasProvider))
              IconButton(
                tooltip: context.l10n.commonShows,
                onPressed: () => context.go('/shows'),
                icon: Icon(
                  path == '/shows' ? Icons.event : Icons.event_outlined,
                  color: path == '/shows' ? Pm.text : Pm.subdued,
                ),
              ),
            const ChatButton(),
            const DownloadsBell(),
            const SizedBox(width: 4),
            _Avatar(name: session?.userName ?? ''),
            const SizedBox(width: 12),
            if (!Platform.isMacOS) const _WindowButtons(),
          ],
        ),
      ),
    );
  }
}

class _AppMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: context.l10n.topBarMenu,
      icon: Icon(Icons.more_horiz, color: Pm.subdued),
      onSelected: (v) {
        switch (v) {
          case 'settings':
            context.go('/settings');
          case 'logout':
            ref.read(sessionProvider.notifier).logout();
          case 'quit':
            windowManager.close();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'settings',
          child: Text(context.l10n.commonSettings),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Text(context.l10n.topBarLogoutAccount),
        ),
        PopupMenuItem(value: 'quit', child: Text(context.l10n.topBarQuit)),
      ],
    );
  }
}

class _Avatar extends ConsumerWidget {
  final String name;
  const _Avatar({required this.name});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: name,
      offset: const Offset(0, 48),
      onSelected: (v) {
        if (v == 'profile') context.go('/profile');
        if (v == 'settings') context.go('/settings');
        if (v == 'logout') ref.read(sessionProvider.notifier).logout();
        if (v == 'add') addAccount(ref);
        if (v.startsWith('acc:')) switchAccount(ref, v.substring(4));
      },
      itemBuilder: (_) {
        final n = ref.read(sessionProvider.notifier);
        final others = [
          for (final a in n.accounts)
            if (a.id != n.activeId) a,
        ];
        return [
          PopupMenuItem(
            enabled: false,
            child: Text(name, style: TextStyle(color: Pm.subdued)),
          ),
          for (final a in others)
            PopupMenuItem(
              value: 'acc:${a.id}',
              child: Text(context.l10n.accountsOn(a.userName, a.host)),
            ),
          PopupMenuItem(value: 'add', child: Text(context.l10n.accountsAdd)),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'profile',
            child: Text(context.l10n.commonProfile),
          ),
          PopupMenuItem(
            value: 'settings',
            child: Text(context.l10n.commonSettings),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Text(context.l10n.topBarLogout),
          ),
        ];
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: Pm.elevated, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: const MyPhoto(size: 32),
      ),
    );
  }
}

class _WindowButtons extends StatelessWidget {
  const _WindowButtons();
  @override
  Widget build(BuildContext context) {
    Widget b(IconData i, VoidCallback f, {bool close = false}) =>
        _WinBtn(i, f, close: close);
    return Row(
      children: [
        b(Icons.remove, () => windowManager.minimize()),
        b(Icons.crop_square, () async {
          if (await windowManager.isMaximized()) {
            windowManager.unmaximize();
          } else {
            windowManager.maximize();
          }
        }),
        b(Icons.close, () => windowManager.close(), close: true),
      ],
    );
  }
}

class _WinBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool close;
  const _WinBtn(this.icon, this.onTap, {this.close = false});
  @override
  State<_WinBtn> createState() => _WinBtnState();
}

class _WinBtnState extends State<_WinBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 46,
        height: 64,
        color: _hover
            ? (widget.close ? const Color(0xFFE81123) : Colors.white10)
            : Colors.transparent,
        child: Icon(widget.icon, size: 16, color: Pm.text),
      ),
    ),
  );
}
