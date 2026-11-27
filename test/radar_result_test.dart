import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/api/catalog.dart';
import 'package:pudim_music/l10n/app_localizations_pt.dart';
import 'package:pudim_music/ui/widgets/mix_button.dart';

void main() {
  final l = L10nPt();

  test('the Radar run reads the queued releases and the notes', () {
    final info = MadeInfo.fromJson({
      'running': false,
      'tracks': 42,
      'queued': [
        {
          'artist': 'Banda',
          'albums': ['Um', 'Dois'],
          'job': 'x',
        },
        {
          'artist': 'Outra',
          'albums': ['Três', 'Quatro'],
        },
      ],
      'not_found': ['Fulano - Disco'],
      'checked': 1700000000,
      'note': 'Siga artistas para mais lançamentos',
    });
    expect(info.queued.length, 2);
    expect(info.notFound, ['Fulano - Disco']);
    expect(info.checked, isNotNull);
    expect(
      madeResult(l, 'radar', info),
      'Radar de Novidades: 42 músicas\n'
      'Baixando 4 lançamento(s): Banda – Um, Banda – Dois, Outra – Três…\n'
      'Siga artistas para mais lançamentos',
    );
  });

  test('an error wins, and the daylist says nothing extra', () {
    expect(
      madeResult(l, 'radar', MadeInfo.fromJson({'error': 'sem Deezer'})),
      'O Radar não atualizou: sem Deezer',
    );
    expect(madeResult(l, 'daylist', MadeInfo.fromJson({'tracks': 30})), null);
    expect(
      madeResult(l, 'radar', MadeInfo.fromJson({'tracks': 10})),
      'Radar de Novidades: 10 músicas',
    );
  });
}
