import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/models.dart';

/// Responde com JSON fixo por caminho e guarda as requisições feitas.
class FakeAdapter implements HttpClientAdapter {
  final Map<String, Object> responses;
  final requests = <RequestOptions>[];
  FakeAdapter(this.responses);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = responses[options.path] ?? {'Items': []};
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Jellyfin client(FakeAdapter a) => Jellyfin(
  baseUrl: 'http://jf',
  deviceId: 'd',
  deviceName: 'teste',
  token: 't',
  userId: 'u',
  adapter: a,
);

void main() {
  test(
    'Seguir/Deixar de seguir usa POST/DELETE em /UserFavoriteItems',
    () async {
      final a = FakeAdapter({});
      final c = client(a);
      await c.setFavorite('art', true);
      await c.setFavorite('art', false);
      expect(a.requests.map((r) => '${r.method} ${r.path}'), [
        'POST /UserFavoriteItems/art',
        'DELETE /UserFavoriteItems/art',
      ]);
      expect(a.requests.first.queryParameters['userId'], 'u');
    },
  );

  test('InstantMix só pede campos que o Jellyfin aceita', () async {
    final a = FakeAdapter({});
    await client(a).instantMix('x');
    final fields = a.requests.single.queryParameters['Fields'] as String;
    expect(fields.split(','), isNot(contains('SongCount')));
    expect(fields.split(','), isNot(contains('ProductionYear')));
  });

  test(
    'Adicionados recentemente usa a biblioteca de música como ParentId',
    () async {
      final a = FakeAdapter({
        '/UserViews': {
          'Items': [
            {'Id': 'filmes', 'CollectionType': 'movies'},
            {'Id': 'mus', 'CollectionType': 'music'},
          ],
        },
        '/Items/Latest': [
          {'Id': 'al', 'Name': 'Álbum', 'Type': 'MusicAlbum'},
        ],
      });
      final latest = await client(a).latestAlbums();
      expect(latest.single.kind, ItemKind.album);
      final q = a.requests.last.queryParameters;
      expect(q['ParentId'], 'mus');
      expect(q.containsKey('IncludeItemTypes'), isFalse);
    },
  );
}
