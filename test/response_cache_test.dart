import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/response_cache.dart';

/// Responde uma playlist enquanto `up`; depois finge que a rede caiu.
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
      throw DioException.connectionError(requestOptions: o, reason: 'sem rede');
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
  test('sem internet a biblioteca vem da cópia no aparelho', () async {
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
    ); // grava em segundo plano

    net.up = false;
    expect((await api.playlists()).single.name, 'Rock');
    expect(cache.offline.value, isTrue);

    // Durante os 30 s sem rede nem tenta o servidor.
    final before = net.calls;
    expect((await api.playlists()).single.name, 'Rock');
    expect(net.calls, before);
    cache.markOnline();
  });

  test('chave não depende da ordem dos parâmetros', () {
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
