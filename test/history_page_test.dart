import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/api/catalog.dart';
import 'package:pudim_music/features/recap/history_page.dart';
import 'package:pudim_music/features/recap/recap_page.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';
import 'package:pudim_music/state/session.dart';
import 'package:pudim_music/ui/theme.dart';

/// Recap shows only the current year (no year pills); Settings > History has every year, the
/// months of the chosen year and the full list of plays.
class _FakeCatalog extends Catalog {
  _FakeCatalog() : super('t', baseUrl: 'http://fake');
  final asked = <(int?, int?)>[];
  String? before;

  @override
  Future<(List<int>, Map<String, dynamic>?)> recap({
    int? year,
    int? month,
  }) async {
    asked.add((year, month));
    return (
      [2026, 2025, 2024],
      <String, dynamic>{
        'year': year,
        'plays': 10,
        'minutes': 100,
        'months_avail': [10, 11],
      },
    );
  }

  @override
  Future<(List<Map<String, dynamic>>, bool)> history({
    String? before,
    int limit = 100,
  }) async {
    this.before = before;
    return (
      [
        {
          'ts': '2026-11-20 10:05:00',
          'title': 'Song A',
          'artist': 'Artist',
          'album': 'Album',
          'source': 'plugin',
        },
        {
          'ts': '2026-11-19 09:00:00',
          'title': 'Song B',
          'artist': 'Other',
          'source': 'spotify',
        },
      ],
      before == null,
    );
  }

  @override
  Future<Map<String, dynamic>> spotifyHistory() async => {'plays': 0};

  @override
  String recapImage({
    required String tipo,
    String? item,
    String? artista,
    String? album,
  }) => '';
}

Widget _app(_FakeCatalog cat, Widget home) => ProviderScope(
  overrides: [catalogProvider.overrideWithValue(cat)],
  child: MaterialApp(
    theme: buildTheme(),
    locale: const Locale('en'),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: Scaffold(body: home),
  ),
);

void main() {
  setUp(() {
    final tester = TestWidgetsFlutterBinding.ensureInitialized();
    tester.platformDispatcher.views.first.physicalSize = const Size(390, 2400);
    tester.platformDispatcher.views.first.devicePixelRatio = 1;
  });

  testWidgets('recap asks for the current year and shows no year pills', (
    tester,
  ) async {
    final cat = _FakeCatalog();
    await tester.pumpWidget(_app(cat, const RecapPage()));
    await tester.pump();
    await tester.pump();
    expect(cat.asked.first, (DateTime.now().year, null));
    expect(find.text('2025'), findsNothing);
    expect(find.text('2024'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('history lists years and months, and the plays', (tester) async {
    final cat = _FakeCatalog();
    await tester.pumpWidget(_app(cat, const HistoryPage()));
    await tester.pump();
    await tester.pump();
    expect(find.text('2025'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    await tester.tap(find.text('2024'));
    await tester.pump();
    await tester.pump();
    expect(cat.asked.last, (2024, null));
    expect(find.text('November'), findsOneWidget);
    await tester.tap(find.text('November'));
    await tester.pump();
    await tester.pump();
    expect(cat.asked.last, (2024, 11));

    await tester.tap(find.text('Plays'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Song A'), findsOneWidget);
    expect(find.text('Song B'), findsOneWidget);
    expect(find.text('imported'), findsOneWidget);
    expect(find.text('10:05'), findsOneWidget);
    await tester.tap(find.text('Load more'));
    await tester.pump();
    await tester.pump();
    expect(cat.before, '2026-11-19 09:00:00');
    expect(find.text('Load more'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
