import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/catalog.dart';
import 'package:pudim_music/features/catalog/album_picker_page.dart';

void main() {
  test('plano de álbuns do painel vira lista com estúdio e etiquetas', () {
    final p = AlbumPlan.fromJson({
      'artist': 'Dream Theater',
      'query': 'dream theater',
      'have': 17,
      'skipped_one_song': 2,
      'missing': [
        {
          'rgid': 'a',
          'title': 'Parasomnia',
          'year': '2025',
          'type': 'Album',
          'secondary': [],
        },
        {
          'rgid': 'b',
          'title': 'Live at Budokan',
          'year': 2004,
          'type': 'Album',
          'secondary': ['Live'],
          'partial': true,
        },
      ],
    });
    expect(p.query, 'dream theater');
    expect(p.missing.map((a) => a.studio), [true, false]);
    expect(p.missing[1].year, '2004');
    expect(p.missing[1].partial, isTrue);
    expect(planTag(p.missing[1]), 'Álbum · ao vivo');
  });
}
