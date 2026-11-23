import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/response_cache.dart';

/// Answers with a playlist while `up`; afterwards pretends the network went down.
class FlakyAdapter implements HttpClientAdapter {
  bool up = true;
  int calls = 0;
  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    if (!up) {
      throw DioException.connectionError(
        requestOptions: o,
        reason: 'no network',
      );
    }
    return ResponseBody.fromString(
      jsonEncode({
        'Items': [
          {'Id': 'p1', 'Name': 'Rock', 'Type': 'Playlist'},
        ],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'without internet the library comes from the copy on the device',
    () async {
      final tmp = await Directory.systemTemp.createTemp('pudim_cache');
      addTearDown(() => tmp.delete(recursive: true));
      final cache = await ResponseCache.open(tmp.path);
      final net = FlakyAdapter();
      final api = Jellyfin(
        baseUrl: 'http://jf',
        deviceId: 'd',
        deviceName: 'teste',
        token: 't',
        userId: 'u',
        adapter: net,
        cache: cache,
      );

      expect((await api.playlists()).single.name, 'Rock');
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      ); // written in the background

      net.up = false;
      expect((await api.playlists()).single.name, 'Rock');
      expect(cache.offline.value, isTrue);

      // During the 30 s without network it does not even try the server.
      final before = net.calls;
      expect((await api.playlists()).single.name, 'Rock');
      expect(net.calls, before);
      cache.markOnline();
    },
  );

  test('key does not depend on parameter order', () {
    expect(
      ResponseCache.keyOf('/Items', {'a': 1, 'b': 2}),
      ResponseCache.keyOf('/Items', {'b': 2, 'a': 1}),
    );
    expect(
      ResponseCache.keyOf('/Items', {'a': 1}),
      isNot(ResponseCache.keyOf('/Items', {'a': 2})),
    );
  });
}
