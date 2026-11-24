import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/state/app_theme.dart';
import 'package:pudim_music/ui/theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('no brand names in theme names or descriptions (any language)', () {
    final brands = RegExp(
      r'spotify|youtube|deezer|winamp|windows media|media player|apple music|tidal',
      caseSensitive: false,
    );
    for (final t in appThemes) {
      expect(brands.hasMatch(t.name), isFalse, reason: t.name);
    }
    for (final f in Directory('lib/l10n').listSync()) {
      if (!f.path.endsWith('.arb')) continue;
      final m = jsonDecode(File(f.path).readAsStringSync()) as Map;
      for (final e in m.entries) {
        if ('${e.key}'.startsWith('theme')) {
          expect(
            brands.hasMatch('${e.value}'),
            isFalse,
            reason: '${f.path} ${e.key}',
          );
        }
      }
    }
  });

  test('five themes with unique, stable ids; default first', () {
    expect(appThemes.map((t) => t.id), [
      'night',
      'red',
      'wave',
      'retro',
      'classic',
    ]);
    expect(themeById(null).id, 'night');
    expect(themeById('gone').id, 'night');
    expect(themeById('retro').name, 'Retrô');
  });

  test('every theme builds and stays readable', () {
    for (final t in appThemes) {
      final d = buildTheme(t);
      expect(d.colorScheme.primary, t.accent);
      expect(_contrast(t.text, t.base), greaterThan(7), reason: t.id);
      expect(_contrast(t.subdued, t.base), greaterThan(4.5), reason: t.id);
      expect(_contrast(t.onAccent, t.accent), greaterThan(3), reason: t.id);
    }
  });

  testWidgets('switching the theme repaints widgets already on screen', (
    tester,
  ) async {
    addTearDown(() => Pm.current = appThemes.first);
    await tester.pumpWidget(const _Probe());
    Color shown() => tester.widget<ColoredBox>(find.byType(ColoredBox)).color;
    expect(shown(), appThemes.first.accent);
    Pm.current = themeById('retro');
    rebuildAllWidgets();
    await tester.pump();
    expect(shown(), themeById('retro').accent);
  });
}

class _Probe extends StatelessWidget {
  const _Probe();
  @override
  Widget build(BuildContext context) => ColoredBox(color: Pm.accent);
}
