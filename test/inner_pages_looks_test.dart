import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/ui/theme.dart';
import 'package:pudim_music/ui/widgets/common.dart';
import 'package:pudim_music/ui/widgets/page_header.dart';
import 'package:pudim_music/ui/widgets/themed.dart';

/// Inner pages in every theme, at phone and desktop sizes: a page header with actions, chips,
/// a settings panel, empty and loading states, a search field, a dialog, a sheet and a toast.
/// Catches layout errors in each style. With `PUDIM_SHOTS=folder` it also saves one PNG per theme
/// and size there, for a visual check (fonts are loaded from the system when available).
void main() {
  final shots = Platform.environment['PUDIM_SHOTS'];

  setUpAll(() async {
    if (shots == null) return;
    Future<void> load(String family, List<String> files) async {
      final l = FontLoader(family);
      var any = false;
      for (final f in files) {
        final file = File(f);
        if (!file.existsSync()) continue;
        any = true;
        l.addFont(Future.value(ByteData.sublistView(await file.readAsBytes())));
      }
      if (any) await l.load();
    }

    const win = r'C:\Windows\Fonts';
    await load('Segoe UI', ['$win\\segoeui.ttf', '$win\\segoeuib.ttf']);
    await load('Consolas', ['$win\\consola.ttf', '$win\\consolab.ttf']);
    final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '';
    await load('MaterialIcons', [
      '$flutterRoot/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
    ]);
  });

  Widget albumPage() => GradientPage(
    color: const Color(0xFF8C3B2E),
    children: [
      BigHeader(
        cover: Container(
          width: 300,
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0A050), Color(0xFF6A2C70)],
            ),
          ),
        ),
        type: 'Album',
        title: 'Night Drive Sessions',
        description: const Text('Late songs for empty roads.'),
        meta: const Text('Some Artist • 2024 • 12 songs'),
      ),
      ActionBar(
        children: [
          GreenPlayButton(onPressed: () {}),
          const SizedBox(width: 16),
          const Icon(Icons.shuffle, size: 30),
          const SizedBox(width: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Follow')),
        ],
      ),
      PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChipBar(
              children: [
                Chip2('Popular', selected: true, onTap: () {}),
                Chip2('Albums', selected: false, onTap: () {}),
                Chip2('Singles', selected: false, onTap: () {}),
              ],
            ),
            const SmallHeading('Next in queue'),
            const SizedBox(height: 12),
            ThemedPanel(
              child: Row(
                children: [
                  const Expanded(child: Text('Autoplay')),
                  Switch(value: true, onChanged: (_) {}),
                ],
              ),
            ),
            const EmptyState(
              icon: Icons.queue_music,
              title: 'Your queue is empty',
              subtitle: 'Add songs to see them here.',
            ),
            const Center(child: ThemedLoading()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ],
  );

  Widget overlays(BuildContext context) {
    final sb = searchBox(focused: true, phone: true);
    return Container(
      color: Pm.base,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 46,
            decoration: sb.box,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.search, color: sb.hint),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'What do you want to hear?',
                    style: TextStyle(color: sb.hint),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AlertDialog(
            title: const Text('Extras server'),
            content: const Text('Address of the extras server.'),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              FilledButton(onPressed: () {}, child: const Text('Save')),
            ],
          ),
          const Spacer(),
          Material(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            shape: Theme.of(context).bottomSheetTheme.shape,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('Like'),
                  ),
                  ListTile(
                    leading: Icon(Icons.queue_music),
                    title: Text('Add to queue'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> save(WidgetTester tester, Key key, String name) async {
    if (shots == null) return;
    await tester.runAsync(() async {
      final ro = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
      final img = await ro.toImage();
      final png = await img.toByteData(format: ui.ImageByteFormat.png);
      Directory(shots).createSync(recursive: true);
      File('$shots/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  for (final size in const [Size(390, 844), Size(1280, 800)]) {
    final label = size.width < 600 ? 'phone' : 'desktop';
    testWidgets('inner pages render in every theme ($label)', (tester) async {
      addTearDown(() => Pm.current = appThemes.first);
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      for (final t in appThemes) {
        Pm.current = t;
        const k = Key('shot');
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(t),
              home: RepaintBoundary(
                key: k,
                child: Scaffold(
                  body: Row(
                    children: [
                      Expanded(flex: 3, child: albumPage()),
                      if (size.width >= 600)
                        Expanded(flex: 2, child: Builder(builder: overlays)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull, reason: '${t.id} $label');
        final ctx = tester.element(find.byType(Scaffold));
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Added to Liked Songs'), width: 300),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 800));
        expect(find.text('Added to Liked Songs'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '${t.id} $label toast');
        await save(tester, k, '${t.id}_$label');
        if (size.width < 600) {
          // Phone: the overlays get their own screen.
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: buildTheme(t),
                home: RepaintBoundary(
                  key: k,
                  child: Scaffold(body: Builder(builder: overlays)),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull, reason: '${t.id} overlays');
          await save(tester, k, '${t.id}_${label}_overlays');
        }
        await tester.pumpWidget(const SizedBox());
      }
    });
  }
}
