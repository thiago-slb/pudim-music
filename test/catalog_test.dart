import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/catalog.dart';
import 'package:pudim_music/api/jellyfin.dart';
import 'package:pudim_music/api/models.dart';

class _Fake implements HttpClientAdapter {
  final Map<String, Object> responses;
  final requests = <RequestOptions>[];
  _Fake(this.responses);

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(o);
    return ResponseBody.fromString(
      jsonEncode(responses[o.path] ?? {}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _cover =
    'https://cdn-images.dzcdn.net/images/cover/abc/1000x1000-000000-80-0-0.jpg';

void main() {
  test('faixa do catálogo vira Item com nuvem, capa e ids com prefixo', () {
    final t = Item.fromCatalog({
      'kind': 'track',
      'deezer_id': 11,
      'title': 'Oceano',
      'artist': 'Djavan',
      'artist_id': 22,
      'album': 'Djavan',
      'album_id': 33,
      'duration': 245,
      'cover': _cover,
      'jellyfin_id': null,
    });
    expect(t.id, 'dzt11');
    expect(t.cloud, isTrue);
    expect(t.isCatalog, isTrue);
    expect(t.deezerId, 11);
    expect(t.albumId, 'dza33');
    expect(t.mainArtist!.id, 'dzr22');
    expect(t.duration, const Duration(seconds: 245));
    final api = Jellyfin(baseUrl: 'http://jf', deviceId: 'd', deviceName: 'x');
    expect(api.imageUrl(t.imageItemId, size: 64), contains('/120x120-'));
  });

  test('o que já está na biblioteca usa o id do Jellyfin e não tem nuvem', () {
    final t = Item.fromCatalog({
      'kind': 'track',
      'deezer_id': 12,
      'title': 'Sina',
      'artist': 'Djavan',
      'album_id': 34,
      'cover': _cover,
      'jellyfin_id': 'abc123',
    });
    expect(t.id, 'abc123');
    expect(t.cloud, isFalse);
    expect(t.isCatalog, isFalse);
  });

  test('busca e download falam com /api/player e mandam o token', () async {
    final fake = _Fake({
      '/api/player/search': {
        'tracks': [
          {'kind': 'track', 'deezer_id': 1, 'title': 'A', 'artist': 'X'},
        ],
        'albums': [],
        'artists': [
          {'kind': 'artist', 'deezer_id': 2, 'title': 'X'},
        ],
        'playlists': [],
      },
      '/api/player/download': {'id': 'j1', 'already': true},
    });
    final c = Catalog('tok', baseUrl: 'https://painel', adapter: fake);
    final r = await c.search('x');
    expect(r.tracks.single.id, 'dzt1');
    expect(r.artists.single.kind, ItemKind.artist);
    expect(await c.download('track', 1), isTrue);
    expect(
      fake.requests.first.headers['Authorization'],
      'MediaBrowser Token="tok"',
    );
    expect(fake.requests.last.data, {'kind': 'track', 'deezer_id': 1});
    expect(c.playUrl(9), 'https://painel/api/player/play/9');
  });

  test('status do job em palavras', () {
    DownloadJob job(String st) => DownloadJob.fromJson({
      'id': '1',
      'status': st,
      'kind': 'track',
      'created': 0,
    });
    expect(job('na_fila').active, isTrue);
    expect(job('concluido').statusLabel, 'Chegou na biblioteca');
    expect(job('erro').failed, isTrue);
  });

  test(
    'faixa guardada para retomar volta igual (inclusive a capa do catálogo)',
    () {
      final t = Item.fromCatalog({
        'kind': 'track',
        'deezer_id': 77,
        'title': 'Vento',
        'artist': 'Y',
        'artist_id': 5,
        'album': 'Ar',
        'album_id': 6,
        'duration': 100,
        'cover': _cover,
      });
      final saved = t.toStore();
      catalogCovers.clear(); // app aberto de novo: capas só do que foi guardado
      final back = Item.fromStore(saved);
      expect(back.id, 'dzt77');
      expect(back.cloud, isTrue);
      expect(back.albumId, 'dza6');
      expect(back.mainArtist!.name, 'Y');
      expect(back.duration, const Duration(seconds: 100));
      expect(catalogCovers['dza6'], _cover);
    },
  );
}
