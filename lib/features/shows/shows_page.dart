import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/common.dart';

final showsProvider = FutureProvider.autoDispose<ShowsData>(
  (ref) => ref.watch(catalogProvider).shows(),
);

const _months = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', //
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];
const _week = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];

bool _isBrazil(ShowEvent e) {
  final c = e.country.toLowerCase();
  return c == 'br' || c == 'brasil' || c == 'brazil';
}

/// Shows dos artistas que você segue, numa linha do tempo (próximos e os que já aconteceram).
class ShowsPage extends ConsumerStatefulWidget {
  const ShowsPage({super.key});
  @override
  ConsumerState<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends ConsumerState<ShowsPage> {
  bool _past = false;
  bool _brazil = false;
  Timer? _again;

  @override
  void dispose() {
    _again?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(showsProvider);
    final compact = isCompact(context);
    final side = compact ? 16.0 : 32.0;
    final d = data.value;
    // Ainda buscando alguns artistas no MusicBrainz: atualiza sozinho.
    if (d != null && d.pending > 0 && _again == null) {
      _again = Timer(const Duration(seconds: 20), () {
        _again = null;
        if (mounted) ref.invalidate(showsProvider);
      });
    }
    var list = d == null ? const <ShowEvent>[] : (_past ? d.past : d.upcoming);
    if (_brazil) list = list.where(_isBrazil).toList();

    final rows = <Widget>[];
    String? month;
    for (final e in list) {
      final m = '${_months[e.day.month - 1]} de ${e.day.year}';
      if (m != month) {
        month = m;
        rows.add(_MonthHeader(m));
      }
      rows.add(_EventRow(e, past: _past));
    }

    return Container(
      color: Pm.base,
      child: RefreshIndicator(
        onRefresh: () async => ref.invalidate(showsProvider),
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, compact ? 64 : 24, side, 160),
          children: [
            const Text(
              'Shows',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              d == null
                  ? 'Dos artistas que você segue'
                  : 'Dos ${d.following} artistas que você segue'
                        '${d.pending > 0 ? ' · procurando shows de ${d.pending}…' : ''}',
              style: const TextStyle(color: Pm.subdued),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip2(
                  'Próximos',
                  gap: 0,
                  selected: !_past,
                  onTap: () => setState(() => _past = false),
                ),
                Chip2(
                  'Já aconteceram',
                  gap: 0,
                  selected: _past,
                  onTap: () => setState(() => _past = true),
                ),
                Chip2(
                  'No Brasil',
                  gap: 0,
                  selected: _brazil,
                  onTap: () => setState(() => _brazil = !_brazil),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (data.isLoading && d == null)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (data.hasError && d == null)
              ErrorBox(
                data.error!,
                onRetry: () => ref.invalidate(showsProvider),
              )
            else if (d != null && d.following == 0)
              const _Empty(
                'Siga artistas (botão Seguir na página do artista) para ver os shows deles aqui.',
              )
            else if (rows.isEmpty)
              _Empty(
                _past
                    ? 'Nenhum show registrado ainda.'
                    : 'Nenhum show marcado por enquanto.'
                          '${d != null && d.pending > 0 ? ' Ainda procurando…' : ''}',
              )
            else
              ...rows,
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'Datas do MusicBrainz (feito por fãs); shows novos podem demorar a aparecer.',
                style: TextStyle(color: Pm.muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;
  const _Empty(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Text(text, style: const TextStyle(color: Pm.subdued)),
  );
}

class _MonthHeader extends StatelessWidget {
  final String text;
  const _MonthHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 6, left: 4),
    child: Text(
      text[0].toUpperCase() + text.substring(1),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    ),
  );
}

/// Uma linha da linha do tempo: data à esquerda, ponto na linha e o cartão do show.
class _EventRow extends StatelessWidget {
  final ShowEvent e;
  final bool past;
  const _EventRow(this.e, {required this.past});

  @override
  Widget build(BuildContext context) {
    final day = e.day;
    final where = [
      if (e.place.isNotEmpty) e.place,
      if (e.city.isNotEmpty && e.city != e.place) e.city,
      if (e.country.isNotEmpty && e.country.length > 2) e.country,
      if (e.country.length == 2) e.country.toUpperCase(),
    ].join(' · ');
    final accent = past ? Pm.muted : Pm.green;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  Text(
                    _week[day.weekday - 1],
                    style: const TextStyle(color: Pm.subdued, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 24,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: Center(
                    child: Container(width: 2, color: Pm.highlight),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Pm.base, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Material(
                color: Pm.elevated,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: e.artistId == null
                      ? null
                      : () => context.push('/artist/${e.artistId}'),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.artist,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  decoration: e.cancelled
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            if (e.cancelled)
                              const _Tag('cancelado', Colors.redAccent)
                            else if (e.type == 'Festival')
                              const _Tag('festival', Pm.subdued),
                          ],
                        ),
                        if (e.name.isNotEmpty)
                          Text(e.name, style: const TextStyle(color: Pm.text)),
                        if (where.isNotEmpty || e.time.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              [
                                if (e.time.isNotEmpty)
                                  e.time.length >= 5
                                      ? e.time.substring(0, 5)
                                      : e.time,
                                if (where.isNotEmpty) where,
                              ].join(' · '),
                              style: const TextStyle(
                                color: Pm.subdued,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(text, style: TextStyle(color: color, fontSize: 11)),
  );
}
