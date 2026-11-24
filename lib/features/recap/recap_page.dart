import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/disk_image.dart';

import 'package:file_picker/file_picker.dart';

import 'recap_share.dart';
import '../../ui/widgets/theme_bits.dart';
import '../../ui/widgets/themed.dart';

/// The Recap only shows on Home in November and December (the page opens all year).
bool recapSeason([DateTime? now]) => (now ?? DateTime.now()).month >= 11;

final recapProvider = FutureProvider.autoDispose
    .family<(List<int>, Map<String, dynamic>?), int?>(
      (ref, year) => ref.watch(catalogProvider).recap(year: year),
    );

/// Recap card for Home (only in Nov/Dec and if there is something to show).
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
          decoration: switch (Pm.current.style) {
            UiStyle.retro => bevel(),
            UiStyle.glass => glass(radius: BorderRadius.circular(Pm.radius)),
            UiStyle.night => BoxDecoration(
              borderRadius: BorderRadius.circular(Pm.radius),
              gradient: const LinearGradient(
                colors: [Color(0xFFE8115B), Color(0xFF7A2BD6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            _ => BoxDecoration(
              borderRadius: BorderRadius.circular(
                Pm.current.style == UiStyle.wave ? 24 : 12,
              ),
              gradient: LinearGradient(
                colors: [Pm.accent, Color.lerp(Pm.accent, Colors.black, 0.6)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.recapTitle(recap['year'] as int),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.recapBannerBody(_n(recap['minutes'])),
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

String _n(Object? v) =>
    NumberFormat.decimalPattern(appL10n.localeName)
        .format((v as num?)?.round() ?? 0);

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
              children: [
                EmptyState(
                  icon: Icons.insights_rounded,
                  title: context.l10n.recapEmpty,
                ),
                const SizedBox(height: 24),
                const SpotifyHistoryCard(),
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
          context.l10n.recapTitle(r['year'] as int),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            icon: const Icon(Icons.ios_share, size: 18),
            label: Text(context.l10n.recapShareCards),
            onPressed: () => showRecapShare(context, r),
          ),
        ),
        const SizedBox(height: 24),
        // Big numbers.
        _Card(
          color: const Color(0xFF1E3264),
          child: Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              _Big(_n(r['minutes']), context.l10n.recapBigMinutes),
              _Big(_n(r['songs']), context.l10n.recapBigSongs),
              _Big(_n(r['artists']), context.l10n.recapBigArtists),
              _Big(_n(r['days']), context.l10n.recapBigDays),
              if ((r['streak'] as num? ?? 0) > 1)
                _Big(_n(r['streak']), context.l10n.recapBigStreak),
            ],
          ),
        ),
        if (artists.isNotEmpty) ...[
          _Title(context.l10n.recapTopArtists),
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
                    subtitle: context.l10n.recapMinutesValue(_n(a['minutes'])),
                    big: i == 0,
                  ),
              ],
            ),
          ),
        ],
        if (songs.isNotEmpty) ...[
          _Title(context.l10n.recapTopSongs),
          _Card(
            color: const Color(0xFF148A08),
            child: Column(
              children: [
                for (final (i, s) in songs.take(10).indexed)
                  _Row(
                    rank: i + 1,
                    image: cover(s),
                    title: '${s['title']}',
                    subtitle: context.l10n.recapPlaysLine(
                      '${s['artist']}',
                      _n(s['plays']),
                    ),
                    onTap: s['item_id'] == null
                        ? null
                        : () async {
                            try {
                              final api = ref.read(apiProvider);
                              final recapName = context.l10n.recapShort;
                              final t = await api.item('${s['item_id']}');
                              await ref.read(playerProvider.notifier).playList([
                                t,
                              ], contextName: recapName);
                            } catch (_) {
                              if (context.mounted) {
                                toastMsg(context, context.l10n.recapSongGone);
                              }
                            }
                          },
                  ),
              ],
            ),
          ),
        ],
        if (albums.isNotEmpty) ...[
          _Title(context.l10n.recapTopAlbums),
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
                            style: TextStyle(color: Pm.subdued, fontSize: 13),
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
          _Title(context.l10n.recapTopGenres),
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
                  decoration: Pm.current.style == UiStyle.retro
                      ? bevel()
                      : BoxDecoration(
                          color: Pm.highlight,
                          borderRadius: BorderRadius.circular(
                            Pm.current.style == UiStyle.ruby ? 8 : 20,
                          ),
                          border: Pm.current.style == UiStyle.glass
                              ? Border.all(
                                  color: Pm.accent.withValues(alpha: 0.5),
                                )
                              : null,
                        ),
                  child: Text(
                    context.l10n.recapGenreLine(
                      '${g['name']}',
                      _n(g['minutes']),
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (months.any((m) => (m['minutes'] as num? ?? 0) > 0)) ...[
          _Title(context.l10n.recapMonthly),
          _Months(months),
        ],
        _Title(context.l10n.recapListeningStyle),
        _Card(
          color: const Color(0xFF2A2A2A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (r['top_hour'] != null)
                _Fact(
                  Icons.schedule,
                  context.l10n.recapFavHour('${r['top_hour']}'),
                ),
              if (r['top_weekday'] != null)
                _Fact(
                  Icons.today,
                  context.l10n.recapFavWeekday(
                    _weekday(context, '${r['top_weekday']}'),
                  ),
                ),
              if (r['top_day'] is Map)
                _Fact(
                  Icons.local_fire_department,
                  context.l10n.recapBiggestDay(
                    _date(context, '${(r['top_day'] as Map)['date']}'),
                    _n((r['top_day'] as Map)['minutes']),
                  ),
                ),
              if ((r['new_artists'] as num? ?? 0) > 0)
                _Fact(
                  Icons.person_add_alt,
                  context.l10n.recapNewArtists(
                        (r['new_artists'] as num).toInt(),
                        _n(r['new_artists']),
                      ) +
                      ((r['new_artists_top'] as List? ?? const []).isEmpty
                          ? ''
                          : ': ${(r['new_artists_top'] as List).take(3).join(', ')}'),
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

/// Merges Spotify's "Extended streaming history" into the Recap (years from before Pudim).
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
          dup > 0
              ? context.l10n.recapSpotifyAddedDup(_n(d['added']), _n(dup))
              : context.l10n.recapSpotifyAdded(_n(d['added'])),
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
        title: Text(ctx.l10n.recapSpotifyRemoveTitle),
        content: Text(ctx.l10n.recapSpotifyRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.recapSpotifyRemoveConfirm),
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
        toastMsg(context, context.l10n.recapSpotifyRemoved(_n(n)));
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
          Text(
            context.l10n.recapSpotifyTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            n > 0
                ? context.l10n.recapSpotifyHasData(
                    _n(n),
                    year(h?['from']),
                    year(h?['to']),
                  )
                : context.l10n.recapSpotifyIntro,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Pm.accent,
                  foregroundColor: Pm.onAccent,
                ),
                onPressed: _busy ? null : _import,
                icon: _busy
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Pm.accent,
                        ),
                      )
                    : const Icon(Icons.upload_file, size: 18),
                label: Text(
                  n > 0
                      ? context.l10n.recapSpotifyImportAnother
                      : context.l10n.recapSpotifyImport,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (n > 0)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  onPressed: _busy ? null : _remove,
                  child: Text(context.l10n.recapSpotifyRemoveBtn),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _date(BuildContext context, String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  try {
    return DateFormat.MMMd(Localizations.localeOf(context).toString())
        .format(d);
  } catch (_) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

const _ptMonths = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];
const _ptWeekdays = [
  'segunda',
  'terça',
  'quarta',
  'quinta',
  'sexta',
  'sábado',
  'domingo',
];

/// The server sends the month in Portuguese; shows it in the interface language.
String _month(BuildContext context, String pt, {bool short = false}) {
  final i = _ptMonths.indexOf(pt);
  if (i < 0) return short && pt.length > 3 ? pt.substring(0, 3) : pt;
  try {
    final f = Localizations.localeOf(context).toString();
    final d = DateTime(2024, i + 1);
    return (short ? DateFormat.MMM(f) : DateFormat.MMMM(f)).format(d);
  } catch (_) {
    return short ? pt.substring(0, 3) : pt;
  }
}

/// The server sends the weekday in Portuguese; shows it in the interface language.
String _weekday(BuildContext context, String pt) {
  final i = _ptWeekdays.indexOf(pt);
  if (i < 0) return pt;
  try {
    return DateFormat.EEEE(Localizations.localeOf(context).toString())
        .format(DateTime(2024, 1, 1 + i));
  } catch (_) {
    return pt;
  }
}

void toastMsg(BuildContext context, String msg) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg, textAlign: TextAlign.center)));

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 32, 0, 12),
    child: SmallHeading(text, size: 22),
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
    // Same card color in every theme, framed in the theme's way.
    decoration: switch (Pm.current.style) {
      UiStyle.retro => bevel(color: Color.lerp(color, Pm.elevated, 0.55)),
      UiStyle.glass => BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.white, 0.3)!,
            color,
            Color.lerp(color, Colors.black, 0.45)!,
          ],
          stops: const [0, 0.5, 1],
        ),
        border: Border.all(color: Colors.white38),
      ),
      UiStyle.wave => BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Pm.accent, 0.6)!],
        ),
      ),
      UiStyle.ruby => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      UiStyle.night => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    },
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
        style: Pm.current.style == UiStyle.retro
            ? TextStyle(fontSize: 32, color: Pm.accent, letterSpacing: 2)
            : TextStyle(
                fontSize: Pm.current.style == UiStyle.wave ? 44 : 36,
                fontWeight: FontWeight.w900,
                letterSpacing: Pm.current.style == UiStyle.wave ? -1.5 : null,
              ),
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
                    context.l10n.recapMonthTooltip(
                      _month(context, '${m['month']}'),
                      _n(m['minutes']),
                    ) +
                    (m['artist'] == null ? '' : ' • ${m['artist']}'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height:
                          120 * ((m['minutes'] as num? ?? 0).toDouble() / most),
                      decoration: BoxDecoration(
                        color:
                            Pm.current.style == UiStyle.night ||
                                Pm.current.style == UiStyle.ruby
                            ? Pm.accent
                            : null,
                        gradient: switch (Pm.current.style) {
                          UiStyle.wave => LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Pm.accent, Colors.pinkAccent],
                          ),
                          UiStyle.glass => LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Pm.accent.withValues(alpha: 0.3),
                              Pm.accent,
                            ],
                          ),
                          UiStyle.retro => LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Pm.accent, Colors.yellow, Colors.red],
                          ),
                          _ => null,
                        },
                        borderRadius: BorderRadius.circular(
                          switch (Pm.current.style) {
                            UiStyle.retro => 0,
                            UiStyle.wave => 8,
                            _ => 3,
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _month(context, '${m['month']}', short: true),
                      style: TextStyle(color: Pm.subdued, fontSize: 11),
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
        Icon(icon, size: 20, color: Pm.accent),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    ),
  );
}
