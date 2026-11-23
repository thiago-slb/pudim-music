import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/catalog.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/ui/widgets/sleep_speed.dart';

void main() {
  test('episódio de podcast vira faixa que toca do endereço dele', () {
    final e = PodcastEpisode.fromJson(
      {
        'guid': 'abcdef0123456789abcd',
        'title': 'Ep 1',
        'url': 'https://cdn.example/ep1.mp3',
        'image': '',
        'date': 1700000000,
        'duration': 3600,
        'progress': {'pos': 120, 'dur': 3600, 'done': false},
      },
      podcast: 'Meu Podcast',
      podcastId: '42',
      cover: 'https://img.example/c.jpg',
    );
    expect(e.image, 'https://img.example/c.jpg');
    expect(e.position, const Duration(minutes: 2));
    final it = e.toItem();
    expect(it.isPodcast, isTrue);
    expect(it.streamUrl, 'https://cdn.example/ep1.mp3');
    expect(it.albumId, 'podshow42');
    expect(catalogCovers[it.id], 'https://img.example/c.jpg');
    final back = Item.fromStore(it.toStore());
    expect(back.streamUrl, it.streamUrl);
  });

  test('show do MusicBrainz e contato com foto', () {
    final s = ShowEvent.fromJson({
      'id': 'x',
      'date': '2026-08-08',
      'name': 'Festival',
      'artist': 'Banda',
      'country': 'BR',
      'cancelled': true,
    });
    expect(s.day, DateTime(2026, 8, 8));
    expect(s.cancelled, isTrue);
    final c = Contact.fromJson({'id': 'u', 'name': 'ana', 'image': 'tag1'});
    expect(c.displayName, 'ana');
    expect(c.image, 'tag1');
    expect(
      Contact.fromJson({'id': 'u', 'name': 'b', 'image': null}).image,
      isNull,
    );
  });

  test('Jam: fila só vem quando muda e os pedidos chegam para o anfitrião', () {
    final t = const Item(id: 'a1', name: 'Música', kind: ItemKind.track);
    final j = JamState.fromJson({
      'id': 'j1',
      'host': 'u1',
      'is_host': true,
      'rev': 3,
      'index': 0,
      'pos_ms': 1500,
      'playing': true,
      'context': 'Teste',
      'ended': false,
      'members': [
        {'id': 'u1', 'name': 'a', 'display_name': 'A'},
      ],
      'queue': [t.toStore()],
      'pending': [t.toStore()],
      'cmds': [
        {'action': 'next'},
      ],
    });
    expect(j.queue!.single.name, 'Música');
    expect(j.pending.single.id, 'a1');
    expect(j.cmds.single['action'], 'next');
    final same = JamState.fromJson({'id': 'j1', 'host': 'u1', 'rev': 3});
    expect(same.queue, isNull);
  });

  test('colaborativa: quem adicionou cada música', () {
    const info = CollabInfo('u1', [
      Contact('u1', 'a', 'Ana'),
      Contact('u2', 'b', 'Beto'),
    ], {'t1': 'u2'});
    expect(info.isCollab, isTrue);
    expect(info.who('t1')?.displayName, 'Beto');
    expect(info.who('t2'), isNull);
    expect(CollabInfo.none.isCollab, isFalse);
  });

  test('Blend e daylist vindos do painel', () {
    final b = BlendInfo.fromJson({
      'user_id': 'u2',
      'name': 'Beto',
      'affinity': 72,
      'common': ['Djavan'],
      'playlist': 'p1',
      'tracks': 50,
    });
    final m = MadeData(
      MadeInfo.fromJson(null),
      MadeInfo.fromJson({'name': 'daylist · rock segunda à noite', 'tracks': 40}),
      [b],
    );
    expect(m.blendWith('u2')?.affinity, 72);
    expect(m.blendWith('u3'), isNull);
    expect(m.daylist.tracks, 40);
    expect(m.radar.playlist, isNull);
  });

  test('ganho de normalização vem do Jellyfin e sobrevive ao salvar a fila', () {
    final t = Item.fromJson({
      'Id': 'a1',
      'Name': 'Faixa',
      'Type': 'Audio',
      'NormalizationGain': -6.5,
    });
    expect(t.normalizationGain, -6.5);
    expect(Item.fromStore(t.toStore()).normalizationGain, -6.5);
    final semAnalise = Item.fromJson({'Id': 'a2', 'Name': 'X', 'Type': 'Audio'});
    expect(Item.fromStore(semAnalise.toStore()).normalizationGain, isNull);
  });

  test('rótulo da velocidade do podcast', () {
    expect(SpeedButton.label(1.0), '1×');
    expect(SpeedButton.label(1.5), '1,5×');
    expect(SpeedButton.label(0.75), '0,75×');
    expect(SpeedButton.label(2.0), '2×');
  });
}
