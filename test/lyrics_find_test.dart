import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/features/lyrics/find_lyrics_button.dart';
import 'package:pudim_music/features/lyrics/lyrics_data.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';
import 'package:pudim_music/state/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Answers with [routes] (path -> status, body); records every request.
class _Fake implements HttpClientAdapter {
  final Map<String, (int, Object?)> routes;
  final calls = <String>[];
  _Fake(this.routes);

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add('${o.method} ${o.uri.path}');
    final hit = routes.entries
        .where((e) => '${o.method} ${o.uri.path}'.endsWith(e.key))
        .firstOrNull;
    final (code, body) = hit?.value ?? (404, null);
    return ResponseBody.fromString(
      jsonEncode(body ?? {}),
      code,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _lrc =
    '[ar:Someone]\n[00:01.50]First line\n[00:04.00][00:20.00]Chorus\nloose';

void main() {
  test('parseLrc reads stamps, skips tags and repeats multi-stamp lines', () {
    final l = parseLrc(_lrc);
    expect(l.synced, isTrue);
    expect(l.lines.map((x) => x.text), ['First line', 'Chorus', 'Chorus']);
    expect(l.lines.first.start, const Duration(seconds: 1, milliseconds: 500));
    expect(l.lines.last.start, const Duration(seconds: 20));
    final plain = parseLrc('one\n\ntwo');
    expect(plain.synced, isFalse);
    expect(plain.lines.map((x) => x.text), ['one', 'two']);
  });

  testWidgets('the button finds lyrics in the public library and keeps them', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final server = _Fake({
      'GET /Audio/t1/RemoteSearch/Lyrics': (200, <Object>[]),
      'POST /Audio/t1/Lyrics': (403, null),
    });
    final library = _Fake({
      'GET /api/get': (404, null),
      'GET /api/search': (
        200,
        [
          {'duration': 300, 'syncedLyrics': '[00:01.00]Wrong song'},
          {'duration': 234, 'plainLyrics': 'plain', 'syncedLyrics': _lrc},
        ],
      ),
    });
    LyricsLibrary.adapter = library;
    final api = Jellyfin(
      baseUrl: 'http://jf',
      deviceId: 'd',
      deviceName: 'test',
      token: 't',
      userId: 'u',
      adapter: server,
    );
    final track = Item(
      id: 't1',
      name: 'Aux âmes',
      kind: ItemKind.track,
      duration: const Duration(seconds: 233),
      artists: const [NameId('a1', 'Artist')],
    );
    final container = ProviderContainer(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        apiProvider.overrideWithValue(api),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(body: Center(child: FindLyricsButton(track))),
        ),
      ),
    );
    await tester.runAsync(
      () async => expect(
        (await container.read(lyricsProvider('t1').future)).isEmpty,
        isTrue,
      ),
    );
    await tester.tap(find.text('Find lyrics'));
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(prefs.getString('lyrics.t1'), _lrc);
    expect(server.calls, contains('POST /Audio/t1/Lyrics'));
    final l = await tester.runAsync(
      () => container.read(lyricsProvider('t1').future),
    );
    expect(l!.lines.first.text, 'First line');
  });
}
