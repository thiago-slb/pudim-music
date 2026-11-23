import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session.dart';

enum RightPanel { none, nowPlaying, queue }

class RightPanelNotifier extends Notifier<RightPanel> {
  @override
  RightPanel build() {
    final v = ref.read(prefsProvider).getString('rightPanel');
    return RightPanel.values.firstWhere(
      (p) => p.name == v,
      orElse: () => RightPanel.nowPlaying,
    );
  }

  void toggle(RightPanel p) => set(state == p ? RightPanel.none : p);

  void set(RightPanel p) {
    state = p;
    ref.read(prefsProvider).setString('rightPanel', p.name);
  }
}

final rightPanelProvider = NotifierProvider<RightPanelNotifier, RightPanel>(
  RightPanelNotifier.new,
);

/// Coluna "Sua Biblioteca" recolhida (só capas) ou aberta.
class SidebarCollapsed extends Notifier<bool> {
  @override
  bool build() => ref.read(prefsProvider).getBool('sidebarCollapsed') ?? false;
  void toggle() {
    state = !state;
    ref.read(prefsProvider).setBool('sidebarCollapsed', state);
  }
}

final sidebarCollapsedProvider = NotifierProvider<SidebarCollapsed, bool>(
  SidebarCollapsed.new,
);

/// Buscas recentes (só locais).
class RecentSearches extends Notifier<List<String>> {
  @override
  List<String> build() =>
      ref.read(prefsProvider).getStringList('recentSearches') ?? const [];

  void add(String q) {
    q = q.trim();
    if (q.isEmpty) return;
    state = [
      q,
      ...state.where((x) => x.toLowerCase() != q.toLowerCase()),
    ].take(10).toList();
    ref.read(prefsProvider).setStringList('recentSearches', state);
  }

  void clear() {
    state = const [];
    ref.read(prefsProvider).remove('recentSearches');
  }
}

final recentSearchesProvider = NotifierProvider<RecentSearches, List<String>>(
  RecentSearches.new,
);
