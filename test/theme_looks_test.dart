import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/features/settings/settings_page.dart';
import 'package:pudim_music/ui/theme.dart';
import 'package:pudim_music/ui/widgets/theme_bits.dart';

/// Renders each theme's building blocks (preview, play button, keys, bars) to catch layout errors
/// in every style. Run with --update-goldens to look at test/goldens/theme_looks.png.
void main() {
  testWidgets('every theme style renders its pieces', (tester) async {
    addTearDown(() => Pm.current = appThemes.first);
    tester.view.physicalSize = const Size(900, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Widget row(AppTheme t) {
      Pm.current = t;
      return Container(
        color: t.base,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ThemePreview(t),
            const SizedBox(width: 12),
            ThemedPlayButton(playing: false, onPressed: () {}),
            const SizedBox(width: 12),
            ThemedPlayButton(light: true, playing: true, onPressed: () {}),
            const SizedBox(width: 12),
            const RetroKey(Icons.skip_next),
            const SizedBox(width: 12),
            const LevelBars(playing: false),
            const SizedBox(width: 12),
            const SizedBox(
              width: 200,
              child: Visualizer(playing: false, height: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Marquee(
                'A very long artist name - and an even longer track title that scrolls',
                style: TextStyle(color: t.accent, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    for (final t in appThemes) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(t),
          home: Scaffold(body: Center(child: row(t))),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: t.id);
    }
  });
}
