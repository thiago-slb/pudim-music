import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/ui/widgets/scroll_memory.dart';

/// A page whose main list holds a sideways carousel, like Home.
Widget _list(String name) => ListView(
  children: [
    SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < 30; i++) SizedBox(width: 100, child: Text('c$i')),
        ],
      ),
    ),
    for (var i = 0; i < 100; i++) SizedBox(height: 50, child: Text('$name $i')),
  ],
);

void main() {
  testWidgets(
    'Back reopens a page where it was left; a new visit starts at the top',
    (tester) async {
      ScrollMemory.reset();
      Page<void> page(Widget c, GoRouterState s) => NoTransitionPage(
        key: s.pageKey,
        child: ScrollMemory(location: s.uri.toString(), child: c),
      );
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', pageBuilder: (_, s) => page(_list('a'), s)),
          GoRoute(path: '/b', pageBuilder: (_, s) => page(_list('b'), s)),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.drag(find.text('a 3'), const Offset(0, -900));
      await tester.pumpAndSettle();
      final left = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels;
      expect(left, greaterThan(500));

      router.go('/b');
      await tester.pumpAndSettle();
      ScrollMemory.markBack('/');
      router.go('/');
      await tester.pumpAndSettle();
      expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .pixels,
        left,
      );

      router.go('/b');
      await tester.pumpAndSettle();
      router.go('/');
      await tester.pumpAndSettle();
      expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .pixels,
        0,
      );
    },
  );
}
