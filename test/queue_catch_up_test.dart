import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/audio/player.dart';

// Guard for build 14: the player moved on to the preloaded track without the queue following, so
// when that track ended "next" replayed it (the song seemed to repeat in Android Auto).
Item _t(String id) => Item(id: id, name: id, kind: ItemKind.track);

void main() {
  final q = [_t('a'), _t('b'), _t('c')];

  test('queue already on the playing track: nothing to do', () {
    expect(catchUpIndex(QueueState(queue: q, index: 1), 'b'), isNull);
  });

  test('player went to the next track by itself: queue moves one ahead', () {
    expect(catchUpIndex(QueueState(queue: q, index: 0), 'a'), isNull);
    expect(catchUpIndex(QueueState(queue: q, index: 0), 'b'), 1);
  });

  test('repeat all wraps to the first track', () {
    final st = QueueState(queue: q, index: 2, repeat: RepeatMode.all);
    expect(catchUpIndex(st, 'a'), 0);
    expect(catchUpIndex(QueueState(queue: q, index: 2), 'a'), isNull);
  });

  test('unknown track or no player source: leaves the queue alone', () {
    expect(catchUpIndex(QueueState(queue: q, index: 0), 'zzz'), isNull);
    expect(catchUpIndex(QueueState(queue: q, index: 0), null), isNull);
  });
}
