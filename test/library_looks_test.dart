import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';
import 'package:pudim_music/state/library.dart';
import 'package:pudim_music/state/session.dart';
import 'package:pudim_music/ui/shell/library_sidebar.dart';
import 'package:pudim_music/ui/theme.dart';
import 'package:pudim_music/ui/widgets/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Your Library header (title, filter pills, search, sort) in every theme on a phone.
/// With PUDIM_SHOTS=folder it also saves a PNG per theme.
void main() {
  final shots = Platform.environment['PUDIM_SHOTS'];
  setUpAll(() async {
    if (shots == null) return;
    Future<void> load(String family, List<String> files) async {
      final l = FontLoader(family);
      for (final f in files) {
        if (File(f).existsSync()) {
          l.addFont(
            Future.value(ByteData.sublistView(File(f).readAsBytesSync())),
          );
        }
      }
      await l.load();
    }

    const win = r'C:\Windows\Fonts';
    await load('Segoe UI', ['$win/segoeui.ttf', '$win/segoeuib.ttf']);
    await load('Consolas', ['$win/consola.ttf']);
    await load('MaterialIcons', [
      '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
    ]);
  });

  for (final t in appThemes) {
    testWidgets('library header renders in ${t.id}', (tester) async {
      addTearDown(() => Pm.current = appThemes.first);
      Pm.current = t;
      tester.view.physicalSize = const Size(390, 300);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const k = Key('shot');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prefsProvider.overrideWithValue(prefs),
            libraryProvider.overrideWith(
              (_) async => const LibraryData([], [], []),
            ),
            likedTracksProvider.overrideWith((_) async => []),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, _) => RepaintBoundary(
                    key: k,
                    child: const Scaffold(body: LibrarySidebar()),
                  ),
                ),
              ],
            ),
            debugShowCheckedModeBanner: false,
            theme: buildTheme(t),
            locale: const Locale('en'),
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: L10n.supportedLocales,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final err = tester.takeException();
      if (shots != null) {
        await tester.runAsync(() async {
          final ro = tester.renderObject<RenderRepaintBoundary>(find.byKey(k));
          final img = await ro.toImage();
          final png = await img.toByteData(format: ui.ImageByteFormat.png);
          Directory(shots).createSync(recursive: true);
          File('$shots/lib_${t.id}.png')
              .writeAsBytesSync(png!.buffer.asUint8List());
        });
      }
      expect(err, isNull);
      // Filter pills share one line, each as wide as its label (never stretched or stacked).
      final pills = find.byType(Chip2);
      expect(pills, findsNWidgets(3));
      final rects = [for (var i = 0; i < 3; i++) tester.getRect(pills.at(i))];
      expect(rects.map((r) => r.top).toSet().length, 1);
      // Starts at the left edge, not centered in the panel.
      expect(rects.first.left, lessThan(40));
      for (final r in rects) {
        expect(r.width, lessThan(200));
      }
      expect(find.byType(PillBar), findsOneWidget);
    });
  }
}
