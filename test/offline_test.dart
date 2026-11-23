import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/models.dart';
import 'package:pudim_music/state/offline.dart';

void main() {
  Item track(String id) =>
      Item(id: id, name: 'Faixa $id', kind: ItemKind.track);

  test('downloaded collection round-trips unchanged from the index', () {
    final c = OfflineCollection('alb1', 'Álbum', track('h'), ['a', 'b']);
    final back = OfflineCollection.fromJson(c.toJson());
    expect(back.id, 'alb1');
    expect(back.name, 'Álbum');
    expect(back.head?.id, 'h');
    expect(back.trackIds, ['a', 'b']);
  });

  test(
    'tracksOf follows the collection order and skips what was not downloaded',
    () {
      final st = OfflineState(
        tracks: {'b': track('b'), 'c': track('c')},
        collections: {
          'p': const OfflineCollection('p', 'P', null, ['c', 'a', 'b']),
        },
      );
      expect(st.tracksOf('p').map((t) => t.id), ['c', 'b']);
      expect(st.saved('p'), isTrue);
      expect(st.has('a'), isFalse);
    },
  );
}
