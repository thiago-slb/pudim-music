import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/page_header.dart';
import '../../ui/widgets/themed.dart';
import 'recap_page.dart';

/// Settings > History: every year's (and month's) recap, and the full list of plays
/// (library and imported history). The Recap page itself only shows the current year.
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});
  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool _plays = false;
  int? _year;
  int? _month;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pad = isCompact(context) ? 12.0 : 32.0;
    final modes = PillBar(
      children: [
        Chip2(
          l.historyRecaps,
          selected: !_plays,
          onTap: () => setState(() => _plays = false),
        ),
        Chip2(
          l.historyPlays,
          selected: _plays,
          onTap: () => setState(() => _plays = true),
        ),
      ],
    );
    final head = <Widget>[
      pageTitle(l.settingsHistory, isCompact(context) ? 32 : 56, maxLines: 1),
      const SizedBox(height: 16),
      modes,
      const SizedBox(height: 16),
    ];
    return Container(
      color: Pm.base,
      child: _plays
          ? _PlaysList(head: head, pad: pad)
          : _recaps(context, head, pad),
    );
  }

  Widget _recaps(BuildContext context, List<Widget> head, double pad) {
    // Phone: clears the floating back button.
    final top = isCompact(context) ? 64.0 : 24.0;
    final key = (year: _year ?? DateTime.now().year, month: _month);
    final data = ref.watch(recapProvider(key));
    Widget framed(Widget child) => ListView(
      padding: EdgeInsets.fromLTRB(pad, top, pad, 48),
      children: [...head, child],
    );
    return data.when(
      loading: () => framed(const LoadingBox()),
      error: (e, _) => framed(
        ErrorBox(e, onRetry: () => ref.invalidate(recapProvider(key))),
      ),
      data: (d) {
        final (years, r) = d;
        // First visit: the newest year with plays.
        if (_year == null && years.isNotEmpty && years.first != key.year) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _year = years.first);
          });
        }
        final months = [
          for (final m in (r?['months_avail'] as List? ?? const []))
            (m as num).toInt(),
        ];
        final locale = Localizations.localeOf(context).toString();
        String monthName(int m) {
          try {
            return DateFormat.MMMM(locale).format(DateTime(2024, m));
          } catch (_) {
            return '$m';
          }
        }

        // Wrap: the pills flow onto more lines on a narrow screen.
        final selectors = <Widget>[
          if (years.length > 1) ...[
            PillBar(
              children: [
                for (final y in years)
                  Chip2(
                    '$y',
                    selected: y == key.year,
                    onTap: () => setState(() {
                      _year = y;
                      _month = null;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (months.length > 1) ...[
            PillBar(
              children: [
                Chip2(
                  context.l10n.historyWholeYear,
                  selected: key.month == null,
                  onTap: () => setState(() => _month = null),
                ),
                for (final m in months)
                  Chip2(
                    monthName(m),
                    selected: key.month == m,
                    onTap: () => setState(() => _month = m),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 24),
        ];
        if (r == null || (r['plays'] as num? ?? 0) == 0) {
          return framed(
            Column(
              children: [
                ...selectors,
                EmptyState(
                  icon: Icons.insights_rounded,
                  title: context.l10n.recapEmpty,
                ),
              ],
            ),
          );
        }
        String title;
        if (key.month == null) {
          title = context.l10n.recapTitle(key.year);
        } else {
          try {
            title = DateFormat.yMMMM(locale)
                .format(DateTime(key.year, key.month!));
          } catch (_) {
            title = '${key.month}/${key.year}';
          }
        }
        return RecapView(
          r: r,
          title: title,
          leading: [...head, ...selectors],
          showSpotifyCard: false,
        );
      },
    );
  }
}

/// Every play, newest first, grouped by day, loading 100 at a time.
class _PlaysList extends ConsumerStatefulWidget {
  final List<Widget> head;
  final double pad;
  const _PlaysList({required this.head, required this.pad});
  @override
  ConsumerState<_PlaysList> createState() => _PlaysListState();
}

class _PlaysListState extends ConsumerState<_PlaysList> {
  final _plays = <Map<String, dynamic>>[];
  bool _more = true;
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_loading || !_more) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final before = _plays.isEmpty ? null : _plays.last['ts'] as String?;
      final (page, more) = await ref
          .read(catalogProvider)
          .history(before: before);
      if (!mounted) return;
      setState(() {
        _plays.addAll(page);
        _more = more;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    DateTime? parse(Object? ts) => DateTime.tryParse('${ts ?? ''}');
    String day(DateTime d) {
      try {
        return DateFormat.yMMMMEEEEd(locale).format(d);
      } catch (_) {
        return '${d.year}-${d.month}-${d.day}';
      }
    }

    final rows = <Widget>[];
    String? lastDay;
    for (final p in _plays) {
      final d = parse(p['ts']);
      if (d != null) {
        final label = day(d);
        if (label != lastDay) {
          lastDay = label;
          rows.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
              child: SmallHeading(label, size: 15),
            ),
          );
        }
      }
      rows.add(_PlayRow(p, time: d));
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(
        widget.pad,
        isCompact(context) ? 64 : 24,
        widget.pad,
        48,
      ),
      children: [
        ...widget.head,
        if (_plays.isEmpty && !_loading && _error == null)
          EmptyState(icon: Icons.history, title: context.l10n.historyEmpty),
        ...rows,
        if (_error != null) ErrorBox(_error!, onRetry: _load),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: ThemedLoading()),
          )
        else if (_more && _error == null && _plays.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: OutlinedButton(
                onPressed: _load,
                child: Text(context.l10n.historyLoadMore),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlayRow extends StatelessWidget {
  final Map<String, dynamic> p;
  final DateTime? time;
  const _PlayRow(this.p, {this.time});

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    final retro = t.style == UiStyle.retro;
    final hhmm = time == null
        ? ''
        : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}';
    final sub = [
      p['artist'],
      p['album'],
    ].whereType<String>().where((s) => s.isNotEmpty).join(' • ');
    final imported = p['source'] == 'spotify';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: switch (t.style) {
        UiStyle.retro || UiStyle.glass => BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: retro ? t.highlight : t.accent.withValues(alpha: 0.2),
            ),
          ),
        ),
        _ => null,
      },
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              hhmm,
              style: TextStyle(
                color: retro ? t.accent : t.subdued,
                fontSize: 13,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${p['title'] ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: t.subdued, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (imported)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                context.l10n.historyImported,
                style: TextStyle(color: t.muted, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}
