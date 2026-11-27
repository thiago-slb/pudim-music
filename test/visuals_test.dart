import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/ui/widgets/visuals.dart';

// Each visualization paints without errors, playing and paused, small and full screen.
void main() {
  for (final kind in VisualKind.values) {
    for (final size in const [Size(360, 96), Size(800, 1600)]) {
      testWidgets('${kind.name} paints at $size', (t) async {
        for (final playing in [true, false]) {
          await t.pumpWidget(
            MaterialApp(
              home: Center(
                child: SizedBox.fromSize(
                  size: size,
                  child: AmbientVisual(
                    playing: playing,
                    kind: kind,
                    seed: 'track-1',
                  ),
                ),
              ),
            ),
          );
          for (var i = 0; i < 5; i++) {
            await t.pump(const Duration(milliseconds: 120));
          }
          expect(t.takeException(), isNull);
        }
        await t.pumpWidget(const SizedBox());
      });
    }
  }
}
