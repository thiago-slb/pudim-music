import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';
import 'package:pudim_music/router.dart';
import 'package:pudim_music/state/session.dart';
import 'package:pudim_music/ui/theme.dart';
import 'package:pudim_music/ui/widgets/disk_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Opens every section of the app on a phone, in every theme, with a fake server, and checks
/// that nothing throws. With PUDIM_SHOTS=folder it saves a PNG per section and theme, to look
/// for parts that do not follow the theme.

Map<String, dynamic> _item(String id, String type, String name) => {
  'Id': id,
  'Name': name,
  'Type': type,
  'AlbumId': 'al1',
  'Album': 'Album Name',
  'ArtistItems': [
    {'Id': 'ar1', 'Name': 'Artist Name'},
  ],
  'AlbumArtists': [
    {'Id': 'ar1', 'Name': 'Artist Name'},
  ],
  'RunTimeTicks': 2000000000,
  'ProductionYear': 2024,
  'IndexNumber': 1,
  'ChildCount': 10,
  'UserData': {'IsFavorite': true, 'PlayCount': 3},
  'Overview': 'Short text about it.',
  'DateCreated': '2026-01-01T00:00:00Z',
};

final _items = [
  for (var i = 0; i < 6; i++) _item('t$i', 'Audio', 'Song $i'),
  _item('al1', 'MusicAlbum', 'Album Name'),
  _item('ar1', 'MusicArtist', 'Artist Name'),
  _item('pl1', 'Playlist', 'Playlist Name'),
];

/// A 1x1 colored pixel for every cover.
const _png =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

/// Answers the Jellyfin calls with the items above; the extras server is left out.
class _FakeServer implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final p = o.uri.path;
    if (p.contains('/Images/')) {
      return ResponseBody.fromBytes(base64Decode(_png), 200);
    }
    Object? body;
    final single = RegExp(r'/Items/(\w+)$').firstMatch(p);
    if (single != null) {
      body = _items.firstWhere(
        (i) => i['Id'] == single.group(1),
        orElse: () => _items.first,
      );
    } else if (p.contains('Lyrics')) {
      body = {
        'Lyrics': [
          {'Text': 'First line', 'Start': 0},
          {'Text': 'Second line', 'Start': 20000000},
        ],
      };
    } else if (p.endsWith('/Views')) {
      body = {
        'Items': [
          {'Id': 'v1', 'Name': 'Music', 'CollectionType': 'music'},
        ],
      };
    } else if (p.startsWith('/Users/u') && !p.contains('Items')) {
      body = {'Id': 'u', 'Name': 'Tester'};
    } else {
      body = {'Items': _items, 'TotalRecordCount': _items.length};
    }
    if (o.uri.host != 'jf') {
      return ResponseBody.fromString('{}', 404);
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeSession extends SessionNotifier {
  @override
  Future<Session?> build() async => Session(
    Jellyfin(
      baseUrl: 'http://jf',
      deviceId: 'd',
      deviceName: 'test',
      token: 't',
      userId: 'u',
      adapter: _FakeServer(),
    ),
    'Tester',
  );
}

const _sections = [
  '/',
  '/search',
  '/library',
  '/album/al1',
  '/artist/ar1',
  '/playlist/pl1',
  '/collection/tracks',
  '/collection/offline',
  '/shows',
  '/recap',
  '/history',
  '/settings',
  '/profile',
  '/chat',
  '/queue',
  '/playing',
  '/lyrics',
];

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
    testWidgets('every section renders in ${t.id}', (tester) async {
      addTearDown(() => Pm.current = appThemes.first);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({'theme': t.id, 'extrasUrl': ''});
      final prefs = await SharedPreferences.getInstance();
      Pm.current = t;
      const k = Key('shot');
      DiskImage.adapter = _FakeServer();
      final container = ProviderContainer(
        overrides: [
          prefsProvider.overrideWithValue(prefs),
          sessionProvider.overrideWith(_FakeSession.new),
        ],
      );
      addTearDown(container.dispose);
      await container.read(sessionProvider.future);
      final router = container.read(routerProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: RepaintBoundary(
            key: k,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(t),
              locale: const Locale('en'),
              localizationsDelegates: appLocalizationsDelegates,
              supportedLocales: L10n.supportedLocales,
              routerConfig: router,
            ),
          ),
        ),
      );
      final errors = <String>[];
      for (final s in _sections) {
        router.go(s);
        for (var i = 0; i < 6; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 30)),
          );
          await tester.pump(const Duration(milliseconds: 100));
        }
        final e = tester.takeException();
        if (e != null) errors.add('$s: $e');
        if (shots != null) {
          await tester.runAsync(() async {
            final ro = tester.renderObject<RenderRepaintBoundary>(
              find.byKey(k),
            );
            final img = await ro.toImage();
            final png = await img.toByteData(format: ui.ImageByteFormat.png);
            final name = s == '/'
                ? 'home'
                : s.substring(1).replaceAll('/', '_');
            Directory(shots).createSync(recursive: true);
            File('$shots/sec_${t.id}_$name.png')
                .writeAsBytesSync(png!.buffer.asUint8List());
          });
        }
      }
      // Leaves pending timers (retries, refresh) behind before the tree goes.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(minutes: 5));
      expect(errors, isEmpty);
    });
  }
}
