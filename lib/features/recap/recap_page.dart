import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../audio/player.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/disk_image.dart';

import 'package:file_picker/file_picker.dart';
import 'recap_share.dart';

/// A Retrospectiva só aparece na Início em novembro e dezembro (a página abre o ano todo).
bool recapSeason([DateTime? now]) => (now ?? DateTime.now()).month >= 11;

final recapProvider = FutureProvider.autoDispose
    .family<(List<int>, Map<String, dynamic>?), int?>(
      (ref, year) => ref.watch(catalogProvider).recap(year: year),
    );

/// Cartão da Retrospectiva para a Início (só em nov/dez e se houver o que mostrar).
class RecapBanner extends ConsumerWidget {
  const RecapBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    if (!recapSeason()) return const SizedBox.shrink();
    final r = ref.watch(recapProvider(null)).value;
    final recap = r?.$2;
    if (recap == null || (recap['plays'] as num? ?? 0) == 0) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 24),
      child: InkWell(
        borderRadius: BorderRadius.circular(Pm.radius),
        onTap: () => context.go('/recap'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Pm.radius),
            gradient: const LinearGradient(
              colors: [Color(0xFFE8115B), Color(0xFF7A2BD6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sua Retrospectiva ${recap['year']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_n(recap['minutes'])} minutos de música este ano. Veja o que mais tocou.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}

String _n(Object? v) {
  final s = '${(v as num?)?.round() ?? 0}';
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
}

class RecapPage extends ConsumerStatefulWidget {
  const RecapPage({super.key});
  @override
  ConsumerState<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends ConsumerState<RecapPage> {
  int? _year;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(recapProvider(_year));
    return Container(
      color: Pm.base,
      child: data.when(
        loading: () => const LoadingBox(),
        error: (e, _) =>
            ErrorBox(e, onRetry: () => ref.invalidate(recapProvider(_year))),
        data: (d) {
          final (years, r) = d;
          if (r == null || (r['plays'] as num? ?? 0) == 0) {
            return ListView(
              padding: const EdgeInsets.all(32),
              children: const [
                Text(
                  'Ainda não tem reproduções para montar a Retrospectiva.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Pm.subdued),
                ),
                SizedBox(height: 24),
                SpotifyHistoryCard(),
              ],
            );
          }
          return _Recap(
            r: r,
            years: years,
            onYear: (y) => setState(() => _year = y),
          );
        },
      ),
    );
  }
}

class _Recap extends ConsumerWidget {
  final Map<String, dynamic> r;
  final List<int> years;
  final ValueChanged<int> onYear;
  const _Recap({required this.r, required this.years, required this.onYear});

  List<Map<String, dynamic>> _list(String k) => [
    for (final x in (r[k] as List? ?? const []))
      if (x is Map<String, dynamic>) x,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(catalogProvider);
    final compact = isCompact(context);
    final artists = _list('top_artists');
    final songs = _list('top_songs');
    final albums = _list('top_albums');
    final genres = _list('top_genres');
    final months = _list('months');
    final pad = compact ? 12.0 : 32.0;
    String photo(String name) => cat.recapImage(tipo: 'artista', artista: name);
    String cover(Map<String, dynamic> x) => cat.recapImage(
      tipo: 'capa',
      item: x['item_id'] as String?,
      artista: x['artist'] as String?,
      album: x['album'] as String?,
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(pad, 24, pad, 48),
      children: [
        Text(
          'Sua Retrospectiva ${r['year']}',
          style: TextStyle(
            fontSize: compact ? 32 : 56,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        if (years.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final y in years)
                  Chip2(
                    '$y',
                    gap: 0,
                    selected: y == r['year'],
                    onTap: () => onYear(y),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            icon: const Icon(Icons.ios_share, size: 18),
            label: const Text('Compartilhar cartões'),
            onPressed: () => showRecapShare(context, r),
          ),
        ),
        const SizedBox(height: 24),
        // Números grandes.
        _Card(
          color: const Color(0xFF1E3264),
          child: Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              _Big(_n(r['minutes']), 'minutos ouvindo'),
              _Big(_n(r['songs']), 'músicas diferentes'),
              _Big(_n(r['artists']), 'artistas'),
              _Big(_n(r['days']), 'dias com música'),
              if ((r['streak'] as num? ?? 0) > 1)
                _Big(_n(r['streak']), 'dias seguidos, seu recorde'),
            ],
          ),
        ),
        if (artists.isNotEmpty) ...[
          const _Title('Seus artistas do ano'),
          _Card(
            color: const Color(0xFF7A2BD6),
            child: Column(
              children: [
                for (final (i, a) in artists.take(5).indexed)
                  _Row(
                    rank: i + 1,
                    image: photo('${a['name']}'),
                    round: true,
                    title: '${a['name']}',
                    subtitle: '${_n(a['minutes'])} minutos',
                    big: i == 0,
                  ),
              ],
            ),
          ),
        ],
        if (songs.isNotEmpty) ...[
          const _Title('Suas músicas do ano'),
          _Card(
            color: const Color(0xFF148A08),
            child: Column(
              children: [
                for (final (i, s) in songs.take(10).indexed)
                  _Row(
                    rank: i + 1,
                    image: cover(s),
                    title: '${s['title']}',
                    subtitle: '${s['artist']} • ${_n(s['plays'])} vezes',
                    onTap: s['item_id'] == null
                        ? null
                        : () async {
                            try {
                              final api = ref.read(apiProvider);
                              final t = await api.item('${s['item_id']}');
                              await ref.read(playerProvider.notifier).playList([
                                t,
                              ], contextName: 'Retrospectiva');
                            } catch (_) {
                              if (context.mounted) {
                                toastMsg(
                                  context,
                                  'Essa música não está mais na biblioteca',
                                );
                              }
                            }
                          },
                  ),
              ],
            ),
          ),
        ],
        if (albums.isNotEmpty) ...[
          const _Title('Seus álbuns do ano'),
          LayoutBuilder(
            builder: (_, c) {
              final cols = c.maxWidth > 900 ? 5 : (c.maxWidth > 500 ? 4 : 3);
              final w = (c.maxWidth - (cols - 1) * 12) / cols;
              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: [
                  for (final a in albums.take(cols * 2))
                    SizedBox(
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image(
                              image: DiskImage(cover(a)),
                              width: w,
                              height: w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: w,
                                height: w,
                                color: Pm.highlight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${a['album']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${a['artist']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Pm.subdued,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        if (genres.isNotEmpty) ...[
          const _Title('Gêneros que mais tocaram'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in genres)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Pm.highlight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${g['name']} • ${_n(g['minutes'])} min'),
                ),
            ],
          ),
        ],
        if (months.any((m) => (m['minutes'] as num? ?? 0) > 0)) ...[
          const _Title('Mês a mês'),
          _Months(months),
        ],
        const _Title('Seu jeito de ouvir'),
        _Card(
          color: const Color(0xFF2A2A2A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (r['top_hour'] != null)
                _Fact(Icons.schedule, 'Hora favorita: ${r['top_hour']}h'),
              if (r['top_weekday'] != null)
                _Fact(
                  Icons.today,
                  'Dia da semana favorito: ${r['top_weekday']}',
                ),
              if (r['top_day'] is Map)
                _Fact(
                  Icons.local_fire_department,
                  'Seu maior dia: ${_date('${(r['top_day'] as Map)['date']}')}, '
                  '${_n((r['top_day'] as Map)['minutes'])} minutos',
                ),
              if ((r['new_artists'] as num? ?? 0) > 0)
                _Fact(
                  Icons.person_add_alt,
                  '${_n(r['new_artists'])} artistas novos para você'
                  '${(r['new_artists_top'] as List? ?? const []).isEmpty ? '' : ': ${(r['new_artists_top'] as List).take(3).join(', ')}'}',
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SpotifyHistoryCard(),
      ],
    );
  }
}

final _spotifyHistoryProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>(
      (ref) => ref.watch(catalogProvider).spotifyHistory(),
    );

/// Junta o "Histórico de streaming estendido" do Spotify à Retrospectiva (anos de antes do Pudim).
class SpotifyHistoryCard extends ConsumerStatefulWidget {
  const SpotifyHistoryCard({super.key});
  @override
  ConsumerState<SpotifyHistoryCard> createState() => _SpotifyHistoryCardState();
}

class _SpotifyHistoryCardState extends ConsumerState<SpotifyHistoryCard> {
  bool _busy = false;

  Future<void> _import() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip', 'json'],
    );
    final f = picked.firstOrNull;
    if (f == null) return;
    setState(() => _busy = true);
    try {
      final bytes = await f.readAsBytes();
      final d = await ref.read(catalogProvider).importSpotify(bytes, f.name);
      ref.invalidate(recapProvider);
      ref.invalidate(_spotifyHistoryProvider);
      final dup = (d['duplicated'] as num? ?? 0).toInt();
      if (mounted) {
        toastMsg(
          context,
          '${_n(d['added'])} reproduções do Spotify entraram'
          '${dup > 0 ? ' (${_n(dup)} já estavam pelo Pudim)' : ''}.',
        );
      }
    } catch (e) {
      if (mounted) toastMsg(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Pm.elevated,
        title: const Text('Tirar o histórico do Spotify?'),
        content: const Text(
          'A Retrospectiva volta a contar só o que tocou no Pudim/Jellyfin. Dá para importar de novo depois.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Tirar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      final n = await ref.read(catalogProvider).removeSpotifyHistory();
      ref.invalidate(recapProvider);
      ref.invalidate(_spotifyHistoryProvider);
      if (mounted) {
        toastMsg(context, '${_n(n)} reproduções do Spotify removidas');
      }
    } catch (e) {
      if (mounted) toastMsg(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = ref.watch(_spotifyHistoryProvider).value;
    final n = (h?['plays'] as num? ?? 0).toInt();
    String year(Object? ts) => '$ts'.length >= 4 ? '$ts'.substring(0, 4) : '';
    return _Card(
      color: const Color(0xFF1A3D2A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Histórico do Spotify',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            n > 0
                ? '${_n(n)} reproduções do Spotify na sua Retrospectiva '
                      '(${year(h?['from'])} a ${year(h?['to'])}). Pode mandar um arquivo mais novo: '
                      'o que já entrou não repete.'
                : 'Traga os anos de antes do Pudim. No Spotify, vá em Conta > Privacidade > '
                      'Baixe seus dados e marque "Histórico de streaming estendido". Quando o e-mail '
                      'chegar, escolha aqui o my_spotify_data.zip.',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Pm.green,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                ),
                onPressed: _busy ? null : _import,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file, size: 18),
                label: Text(
                  n > 0 ? 'Importar outro arquivo' : 'Importar histórico',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (n > 0)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  onPressed: _busy ? null : _remove,
                  child: const Text('Tirar da Retrospectiva'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _date(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
}

void toastMsg(BuildContext context, String msg) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg, textAlign: TextAlign.center)));

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 32, 0, 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    ),
  );
}

class _Card extends StatelessWidget {
  final Color color;
  final Widget child;
  const _Card({required this.color, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

class _Big extends StatelessWidget {
  final String value, label;
  const _Big(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
      ),
      Text(label, style: const TextStyle(color: Colors.white70)),
    ],
  );
}

class _Row extends StatelessWidget {
  final int rank;
  final String image, title, subtitle;
  final bool round, big;
  final VoidCallback? onTap;
  const _Row({
    required this.rank,
    required this.image,
    required this.title,
    required this.subtitle,
    this.round = false,
    this.big = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = big ? 72.0 : 48.0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(round ? size : 4),
              child: Image(
                image: DiskImage(image),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(width: size, height: size, color: Colors.black26),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: big ? 20 : 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Months extends StatelessWidget {
  final List<Map<String, dynamic>> months;
  const _Months(this.months);
  @override
  Widget build(BuildContext context) {
    final most = months
        .map((m) => (m['minutes'] as num? ?? 0).toDouble())
        .fold<double>(1, (a, b) => b > a ? b : a);
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final m in months)
            Expanded(
              child: Tooltip(
                message:
                    '${m['month']}: ${_n(m['minutes'])} min'
                    '${m['artist'] == null ? '' : ' • ${m['artist']}'}',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height:
                          120 * ((m['minutes'] as num? ?? 0).toDouble() / most),
                      decoration: BoxDecoration(
                        color: Pm.green,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${m['month']}'.substring(0, 3),
                      style: const TextStyle(color: Pm.subdued, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Fact(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Pm.green),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    ),
  );
}
