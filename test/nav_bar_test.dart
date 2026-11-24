import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';
import 'package:pudim_music/ui/mobile/mobile_shell.dart';
import 'package:pudim_music/ui/theme.dart';

/// Guard for build 20: the retro theme put the tabs in a thin strip at the top that read as a
/// title bar, so the navigation looked gone. Every theme must show every tab and react to taps.
void main() {
  for (final t in appThemes) {
    testWidgets('phone tabs are visible and work in ${t.id}', (tester) async {
      addTearDown(() => Pm.current = appThemes.first);
      Pm.current = t;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final tapped = <int>[];
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(t),
          locale: const Locale('en'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Builder(
            builder: (context) {
              ctx = context;
              return Scaffold(
                body: const SizedBox.expand(),
                bottomNavigationBar: MobileNavBar(
                  index: 0,
                  tabs: const ['/', '/search', '/shows', '/library'],
                  onTap: tapped.add,
                ),
              );
            },
          ),
        ),
      );
      final l = ctx.l10n;
      final labels = [
        l.commonHome,
        l.commonSearch,
        l.commonShows,
        l.commonYourLibrary,
      ];
      for (final (i, label) in labels.indexed) {
        final f = find.textContaining(
          RegExp(RegExp.escape(label), caseSensitive: false),
        );
        expect(f, findsOneWidget, reason: '${t.id}: $label');
        final r = tester.getRect(f);
        expect(r.bottom, greaterThan(844 - 120), reason: 'tabs at the bottom');
        await tester.tap(f);
        expect(tapped.last, i);
      }
    });
  }
}
