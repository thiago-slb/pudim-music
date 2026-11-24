import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/ui/theme.dart';
import 'package:pudim_music/ui/widgets/common.dart';

/// Guard for build 20: pills inside a Wrap (Shows "Upcoming / Past", History years and months,
/// recent searches) took the whole line each and stacked one under the other. On a 360 dp phone,
/// in every theme and with a large system font, short pills must share one line and be only as
/// wide as their label.
void main() {
  // Short labels: the test font draws every character as a 14 px box, far wider than the real
  // fonts, so long labels would wrap here for real.
  const labels = ['Hoje', 'Antes', 'BR'];

  for (final t in appThemes) {
    for (final scale in const [1.0, 1.3]) {
      testWidgets('pills share a line at 360 dp (${t.id}, font x$scale)', (
        tester,
      ) async {
        addTearDown(() => Pm.current = appThemes.first);
        Pm.current = t;
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        Widget pills({bool scroll = false}) => PillBar(
          scroll: scroll,
          children: [
            for (final (i, l) in labels.indexed)
              Chip2(l, selected: i == 0, onTap: () {}),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(t),
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 640),
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeyedSubtree(key: const Key('wrap'), child: pills()),
                      const SizedBox(height: 24),
                      KeyedSubtree(
                        key: const Key('scroll'),
                        child: pills(scroll: true),
                      ),
                      const SizedBox(height: 24),
                      // A lone pill in a column must not stretch either.
                      Chip2('Solo', selected: false, onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        for (final group in ['wrap', 'scroll']) {
          final rects = [
            for (final l in labels)
              tester.getRect(
                find.descendant(
                  of: find.byKey(Key(group)),
                  matching: find.text(
                    t.style == UiStyle.retro ? l.toUpperCase() : l,
                  ),
                ),
              ),
          ];
          for (final r in rects.skip(1)) {
            expect(
              (r.center.dy - rects.first.center.dy).abs(),
              lessThan(1),
              reason: '$group: pills on the same line',
            );
          }
        }
        final lone = tester.getSize(
          find
              .ancestor(
                of: find.text(t.style == UiStyle.retro ? 'SOLO' : 'Solo'),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(lone.width, lessThan(200), reason: 'pill as wide as its label');
      });
    }
  }
}
