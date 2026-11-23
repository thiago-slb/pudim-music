import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/disk_image.dart';

final podcastSubsProvider = FutureProvider.autoDispose<List<PodcastShow>>(
  (ref) => ref.watch(catalogProvider).podcastSubs(),
);
final podcastTopProvider = FutureProvider.autoDispose<List<PodcastShow>>(
  (ref) => ref.watch(catalogProvider).podcastTop(),
);
final podcastLatestProvider = FutureProvider.autoDispose<List<PodcastEpisode>>(
  (ref) => ref.watch(catalogProvider).podcastLatest(),
);
final podcastSearchProvider = FutureProvider.autoDispose
    .family<List<PodcastShow>, String>(
      (ref, q) => ref.watch(catalogProvider).podcastSearch(q),
    );
final podcastProvider = FutureProvider.autoDispose.family<PodcastPage, String>((
  ref,
  id,
) async {
  final p = await ref.watch(catalogProvider).podcast(id);
  _remember(p.episodes);
  return p;
});

/// Stores where each episode stopped, so the player can resume from there.
void _remember(List<PodcastEpisode> eps) {
  for (final e in eps) {
    if (e.position > Duration.zero && !e.done) {
      podcastResume['pod${e.guid}'] = e.position;
    }
  }
}

String _date(L10n l, DateTime? d) {
  if (d == null) return '';
  final now = DateTime.now();
  final month = l.podcastsMonthShort('m${d.month}');
  return d.year == now.year
      ? l.podcastsDateThisYear(d.day, month)
      : l.podcastsDateOtherYear(d.day, month, d.year);
}

String _dur(L10n l, Duration d) {
  if (d == Duration.zero) return '';
  final h = d.inHours, min = d.inMinutes % 60;
  return h > 0 ? l.podcastsHoursMin(h, min) : l.podcastsMin(min);
}

/// Plays the episode (and resumes where it stopped, if already started).
Future<void> playEpisode(WidgetRef ref, PodcastEpisode e) async {
  final it = e.toItem();
  if (e.position > Duration.zero && !e.done) {
    podcastResume[it.id] = e.position;
  }
  await ref
      .read(playerProvider.notifier)
      .playList(
        [it],
        contextName: e.podcast,
        contextRoute: '/podcast/${e.podcastId}',
      );
}

class _Art extends StatelessWidget {
  final String url;
  final double size;
  const _Art(this.url, {this.size = 56});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: SizedBox(
      width: size,
      height: size,
      child: url.isEmpty
          ? Container(
              color: Pm.highlight,
              child: const Icon(Icons.podcasts, color: Pm.muted),
            )
          : Image(
              image: DiskImage(url),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Pm.highlight,
                child: const Icon(Icons.podcasts, color: Pm.muted),
              ),
            ),
    ),
  );
}

/// Row of podcast covers (like the music shelves).
class PodcastShelf extends StatelessWidget {
  final String title;
  final List<PodcastShow> shows;
  const PodcastShelf({super.key, required this.title, required this.shows});

  @override
  Widget build(BuildContext context) {
    if (shows.isEmpty) return const SizedBox.shrink();
    final size = isCompact(context) ? 132.0 : 168.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: size + 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: shows.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final s = shows[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => context.push('/podcast/${s.id}'),
                  child: SizedBox(
                    width: size,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Art(s.cover, size: size),
                        const SizedBox(height: 6),
                        Text(
                          s.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          s.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Pm.subdued,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Episode row: cover, title, date/duration, small bar showing how much was already heard.
class EpisodeTile extends ConsumerWidget {
  final PodcastEpisode e;
  final bool showPodcast;
  const EpisodeTile(this.e, {super.key, this.showPodcast = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(playerProvider.select((q) => q.current?.id));
    final playing = cur == 'pod${e.guid}';
    final frac = e.done
        ? 1.0
        : e.duration.inSeconds > 0
        ? (e.position.inSeconds / e.duration.inSeconds).clamp(0.0, 1.0)
        : 0.0;
    final left = e.duration - e.position;
    final l = context.l10n;
    final info = [
      if (showPodcast) e.podcast,
      _date(l, e.date),
      if (e.done)
        l.podcastsPlayed
      else if (e.position > Duration.zero && left > Duration.zero)
        l.podcastsTimeLeft(_dur(l, left))
      else
        _dur(l, e.duration),
    ].where((s) => s.isNotEmpty).join(' · ');
    return InkWell(
      onTap: () => playEpisode(ref, e),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Art(e.image, size: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: playing ? Pm.green : Pm.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Pm.subdued, fontSize: 12),
                  ),
                  if (e.description.isNotEmpty)
                    Text(
                      e.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Pm.muted, fontSize: 12),
                    ),
                  if (frac > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: frac,
                          minHeight: 3,
                          color: Pm.green,
                          backgroundColor: Pm.highlight,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              playing ? Icons.graphic_eq : Icons.play_circle_outline,
              color: playing ? Pm.green : Pm.subdued,
            ),
          ],
        ),
      ),
    );
  }
}

/// Podcasts tab on Home: search, the ones you follow, new episodes and the trending ones in Brazil.
class PodcastsHome extends ConsumerStatefulWidget {
  const PodcastsHome({super.key});
  @override
  ConsumerState<PodcastsHome> createState() => _PodcastsHomeState();
}

class _PodcastsHomeState extends ConsumerState<PodcastsHome> {
  final _q = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subs = ref.watch(podcastSubsProvider).value ?? const [];
    final latest = ref.watch(podcastLatestProvider).value ?? const [];
    final top = ref.watch(podcastTopProvider);
    final found = _query.isEmpty
        ? null
        : ref.watch(podcastSearchProvider(_query));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
          child: TextField(
            controller: _q,
            textInputAction: TextInputAction.search,
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 450),
                () => setState(() => _query = v.trim()),
              );
            },
            decoration: InputDecoration(
              hintText: context.l10n.podcastsSearchHint,
              prefixIcon: const Icon(Icons.search, color: Pm.subdued),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close, color: Pm.subdued),
                      onPressed: () => setState(() {
                        _q.clear();
                        _query = '';
                      }),
                    ),
              filled: true,
              fillColor: Pm.elevated,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(500),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (found != null)
          found.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => ErrorBox(
              e,
              onRetry: () => ref.invalidate(podcastSearchProvider(_query)),
            ),
            data: (list) => list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      context.l10n.podcastsNothingFound,
                      style: const TextStyle(color: Pm.subdued),
                    ),
                  )
                : Column(
                    children: [
                      for (final s in list)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          leading: _Art(s.cover, size: 52),
                          title: Text(
                            s.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            [
                              s.author,
                              s.genre,
                            ].where((x) => x.isNotEmpty).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Pm.subdued),
                          ),
                          onTap: () => context.push('/podcast/${s.id}'),
                        ),
                    ],
                  ),
          )
        else ...[
          PodcastShelf(title: context.l10n.podcastsYours, shows: subs),
          if (latest.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
              child: Text(
                context.l10n.podcastsNewEpisodes,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final e in latest.take(10)) EpisodeTile(e, showPodcast: true),
            const SizedBox(height: 24),
          ],
          top.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                ErrorBox(e, onRetry: () => ref.invalidate(podcastTopProvider)),
            data: (list) => PodcastShelf(
              title: context.l10n.podcastsTrendingBrazil,
              shows: list,
            ),
          ),
        ],
      ],
    );
  }
}

/// A podcast's page: cover, follow and the episodes, which arrive 20 at a time as you scroll
/// (and you can search an episode by title).
class PodcastPageView extends ConsumerStatefulWidget {
  final String id;
  const PodcastPageView(this.id, {super.key});
  @override
  ConsumerState<PodcastPageView> createState() => _PodcastPageViewState();
}

class _PodcastPageViewState extends ConsumerState<PodcastPageView> {
  final _search = TextEditingController();
  Timer? _debounce;
  PodcastPage? _first; // first page that came from the provider
  List<PodcastEpisode> _eps = const [];
  int? _next;
  int _total = 0;
  String _q = '';
  bool _loading = false;
  bool? _subscribed;
  Object? _error;
  int _gen = 0; // discards responses from an old search

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _adopt(PodcastPage p) {
    if (identical(p, _first)) return;
    _first = p;
    _eps = p.episodes;
    _next = p.nextOffset;
    _total = p.total;
    _q = '';
    _error = null;
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading && !reset) return;
    final from = reset ? 0 : _next;
    if (from == null) return;
    final gen = ++_gen;
    setState(() {
      _loading = true;
      _error = null;
      if (reset) {
        _eps = const [];
        _next = null;
      }
    });
    try {
      final p = await ref
          .read(catalogProvider)
          .podcast(widget.id, offset: from, q: _q);
      if (!mounted || gen != _gen) return;
      _remember(p.episodes);
      setState(() {
        _eps = [..._eps, ...p.episodes];
        _next = p.nextOffset;
        _total = p.total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || gen != _gen) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = v.trim();
      if (q == _q) return;
      _q = q;
      _load(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(podcastProvider(widget.id));
    final compact = isCompact(context);
    return Container(
      color: Pm.base,
      child: data.when(
        loading: () => const LoadingBox(),
        error: (e, _) => ErrorBox(
          e,
          onRetry: () => ref.invalidate(podcastProvider(widget.id)),
        ),
        data: (p) {
          _adopt(p);
          final subscribed = _subscribed ?? p.subscribed;
          final header = _header(p, compact, subscribed);
          // header + episodes + footer (loading / error / end)
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              compact ? 12 : 32,
              compact ? 64 : 24,
              compact ? 12 : 32,
              160,
            ),
            itemCount: _eps.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) return header;
              final k = i - 1;
              if (k < _eps.length) {
                if (k >= _eps.length - 5 && _next != null && !_loading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _error == null) _load();
                  });
                }
                return EpisodeTile(_eps[k]);
              }
              return _footer();
            },
          );
        },
      ),
    );
  }

  Widget _footer() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton(
            onPressed: () => _load(reset: _eps.isEmpty),
            child: Text(context.l10n.podcastsLoadFailed),
          ),
        ),
      );
    }
    if (_eps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _q.isEmpty
              ? context.l10n.podcastsNoEpisodes
              : context.l10n.podcastsNoEpisodeMatch(_q),
          style: const TextStyle(color: Pm.subdued),
        ),
      );
    }
    return const SizedBox(height: 8);
  }

  Widget _header(PodcastPage p, bool compact, bool subscribed) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        spacing: 20,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _Art(p.show.cover, size: compact ? 160 : 220),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.podcastsKind,
                  style: const TextStyle(color: Pm.subdued, fontSize: 13),
                ),
                Text(
                  p.show.title,
                  style: TextStyle(
                    fontSize: compact ? 26 : 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(p.show.author, style: const TextStyle(color: Pm.subdued)),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          GreenPlayButton(
            playing: false,
            onPressed: () {
              if (_eps.isNotEmpty) playEpisode(ref, _eps.first);
            },
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Pm.text,
              side: const BorderSide(color: Pm.muted),
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              try {
                await ref
                    .read(catalogProvider)
                    .podcastSubscribe(widget.id, !subscribed);
                setState(() => _subscribed = !subscribed);
                ref.invalidate(podcastSubsProvider);
                ref.invalidate(podcastLatestProvider);
              } catch (e) {
                if (mounted) toast(context, '$e');
              }
            },
            child: Text(
              subscribed
                  ? context.l10n.commonFollowing
                  : context.l10n.commonFollow,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      if (p.show.description.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            p.show.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Pm.subdued, height: 1.4),
          ),
        ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            _total > 0
                ? context.l10n.podcastsEpisodesCount(_total)
                : context.l10n.podcastsEpisodes,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            width: compact ? double.infinity : 280,
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: context.l10n.podcastsFindEpisode,
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Pm.elevated,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
    ],
  );
}
