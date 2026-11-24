import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/theme.dart';
import 'session.dart';

/// Theme chosen in Settings (saved on this device). Changing it repaints the app at once,
/// without restarting and without losing the page or the queue.
class AppThemeChoice extends Notifier<AppTheme> {
  static const _key = 'theme';

  @override
  AppTheme build() {
    final t = themeById(ref.read(prefsProvider).getString(_key));
    Pm.current = t;
    return t;
  }

  void set(AppTheme t) {
    if (t.id == state.id) return;
    ref.read(prefsProvider).setString(_key, t.id);
    Pm.current = t;
    state = t;
    rebuildAllWidgets();
  }
}

final appThemeProvider = NotifierProvider<AppThemeChoice, AppTheme>(
  AppThemeChoice.new,
);

/// Widgets read the colors from [Pm] while building, so every one of them must build again.
void rebuildAllWidgets() {
  void mark(Element e) {
    e.markNeedsBuild();
    e.visitChildren(mark);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(mark);
}
