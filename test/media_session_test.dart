import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/audio/media_session.dart';
import 'package:pudim_music/audio/player.dart';

void main() {
  test('the car gets a window of the queue around the current track', () {
    expect(MediaSession.queueWindow(0, 5), (from: 0, to: 5));
    expect(MediaSession.queueWindow(3, 500), (from: 0, to: 100));
    expect(MediaSession.queueWindow(250, 500), (from: 240, to: 340));
    expect(MediaSession.queueWindow(495, 500), (from: 485, to: 500));
    expect(MediaSession.queueWindow(-1, 0), (from: 0, to: 0));
  });

  test('server covers go through the car cover provider, others stay', () {
    const base = 'https://music.example';
    final u = MediaSession.carArtUri(
      '$base/Items/a1/Images/Primary?maxWidth=300&tag=x',
      base: base,
      appId: 'my.app',
    );
    expect(u.scheme, 'content');
    expect(u.host, 'my.app.carart');
    expect(
      u.queryParameters['u'],
      '$base/Items/a1/Images/Primary?maxWidth=300&tag=x',
    );
    // Catalog covers come from elsewhere: the provider would refuse them.
    final other = MediaSession.carArtUri(
      'https://cdn.example/cover.jpg',
      base: base,
      appId: 'my.app',
    );
    expect(other.scheme, 'https');
    // A look-alike host is not the server.
    expect(
      MediaSession.carArtUri(
        '$base.evil/x.jpg',
        base: base,
        appId: 'my.app',
      ).scheme,
      'https',
    );
  });

  test('like, shuffle and repeat buttons follow the player state', () {
    const t = Item(id: 't1', name: 'Song', kind: ItemKind.track);
    String names(QueueState s) =>
        MediaSession.extraControls(s)
            .map((c) => '${c.customAction!.name}:${c.androidIcon}')
            .join(' ');
    expect(
      names(const QueueState(queue: [t], index: 0)),
      'like:drawable/ic_car_like shuffle:drawable/ic_car_shuffle '
      'repeat:drawable/ic_car_repeat',
    );
    final on = QueueState(
      queue: [t.copyWith(favorite: true)],
      index: 0,
      shuffle: true,
      repeat: RepeatMode.one,
    );
    expect(
      names(on),
      'like:drawable/ic_car_liked shuffle:drawable/ic_car_shuffle_on '
      'repeat:drawable/ic_car_repeat_one',
    );
    // Nothing playing: no like button.
    expect(
      MediaSession.extraControls(const QueueState())
          .map((c) => c.customAction!.name),
      ['shuffle', 'repeat'],
    );
    expect(
      MediaSession.extraControls(const QueueState()).first.action,
      MediaAction.custom,
    );
  });
}
