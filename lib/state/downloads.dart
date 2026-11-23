import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import '../api/models.dart';
import 'library.dart';
import 'session.dart';
import 'notify.dart';
import '../l10n/l10n.dart';

class DownloadsState {
  final List<DownloadJob> jobs;

  /// How many finished since the last time the bell was opened.
  final int unseen;
  const DownloadsState({this.jobs = const [], this.unseen = 0});

  int get active => jobs.where((j) => j.active).length;
}

/// Downloads requested by the app (bell). Polls the panel every 5 s while something is downloading and every
/// 60 s when everything is idle (no SSE: see painel/player_api.py).
class DownloadsNotifier extends Notifier<DownloadsState> {
  Timer? _timer;
  DateTime _seen = DateTime.now();
  DateTime _lastNotices = DateTime(2000);

  @override
  DownloadsState build() {
    ref.onDispose(() => _timer?.cancel());
    _schedule(const Duration(seconds: 2));
    return const DownloadsState();
  }

  void _schedule(Duration d) {
    _timer?.cancel();
    _timer = Timer(d, _poll);
  }

  /// Something was just requested: check right away (the job shows up in ~1 s).
  void refreshSoon() => _schedule(const Duration(seconds: 2));

  Future<void> _poll() async {
    List<DownloadJob> jobs;
    try {
      jobs = await ref.read(catalogProvider).jobs();
    } catch (_) {
      _schedule(const Duration(seconds: 60));
      return;
    }
    final before = {for (final j in state.jobs) j.id: j};
    final arrived = jobs.any(
      (j) => !j.active && !j.failed && (before[j.id]?.active ?? false),
    );
    if (arrived) {
      // New music arrived: the library and search now show the check mark.
      ref.invalidate(libraryProvider);
      ref.invalidate(catalogSearchProvider);
    }
    final unseen = jobs
        .where((j) => !j.active && (j.end ?? j.created).isAfter(_seen))
        .length;
    state = DownloadsState(jobs: jobs, unseen: unseen);
    _notifyJobs(before, jobs);
    await _notices();
    _schedule(Duration(seconds: jobs.any((j) => j.active) ? 5 : 60));
  }

  String _name(DownloadJob j) => j.kind == 'artist' ? j.artist : j.title;

  /// Like Spotify: a pinned notification while downloading and a notice when it arrives.
  void _notifyJobs(Map<String, DownloadJob> before, List<DownloadJob> jobs) {
    final active = jobs.where((j) => j.active).toList();
    if (active.isEmpty) {
      Notify.cancel(Notify.libraryId);
    } else {
      final first = active.first;
      Notify.progress(
        Notify.libraryId,
        active.length == 1
            ? appL10n.stateDownloadingName(_name(first))
            : appL10n.stateDownloadingRequests(active.length),
        active.length == 1
            ? first.statusLabel
            : active.map(_name).take(3).join(', '),
      );
    }
    // First poll: do not announce what had already finished.
    if (before.isEmpty) return;
    for (final j in jobs) {
      final was = before[j.id];
      if (was == null || !was.active || j.active) continue;
      final title = j.ok
          ? appL10n.stateDownloadArrived(_name(j))
          : j.status == 'parcial'
          ? appL10n.stateDownloadPartial(_name(j))
          : appL10n.stateDownloadEnded(_name(j), j.statusLabel.toLowerCase());
      Notify.show(j.id.hashCode & 0x7fffffff, title, j.summary ?? '');
    }
  }

  /// Server notices (release from someone you follow, Descobertas, Mistura, completed playlist).
  Future<void> _notices() async {
    final now = DateTime.now();
    if (now.difference(_lastNotices) < const Duration(seconds: 55)) return;
    _lastNotices = now;
    final prefs = ref.read(prefsProvider);
    final since = prefs.getDouble('noticeSince');
    try {
      final (list, serverNow) = await ref
          .read(catalogProvider)
          .notices(since ?? 1e12);
      if (since != null) {
        for (final n in list) {
          Notify.show(n.ts.hashCode & 0x7fffffff, n.title, n.body);
        }
      }
      // First time: just mark "now" (do not dump the history).
      final last = list.isEmpty ? serverNow : list.last.ts;
      await prefs.setDouble('noticeSince', since == null ? serverNow : last);
    } catch (_) {}
  }

  void markSeen() {
    _seen = DateTime.now();
    state = DownloadsState(jobs: state.jobs, unseen: 0);
  }

  /// Requests the download (track | album | artist) of a catalog item. Returns the notice text.
  Future<String> request(String kind, Item it) async {
    final n = switch (kind) {
      'album' => catalogNumber(it.kind == ItemKind.album ? it.id : it.albumId),
      'artist' => catalogNumber(
        it.kind == ItemKind.artist ? it.id : it.mainArtist?.id,
      ),
      _ => it.deezerId,
    };
    if (n == null) return appL10n.stateNotFromCatalog;
    try {
      final again = await ref.read(catalogProvider).download(kind, n);
      refreshSoon();
      return again
          ? appL10n.stateAlreadyDownloading(kind)
          : appL10n.stateDownloadRequested(kind);
    } on CatalogException catch (e) {
      return e.message;
    }
  }
}

final downloadsProvider = NotifierProvider<DownloadsNotifier, DownloadsState>(
  DownloadsNotifier.new,
);

/// Searches the panel catalog (the app merges it with the library results on the search page).
final catalogSearchProvider = FutureProvider.autoDispose
    .family<CatalogSearch, String>((ref, q) async {
      if (q.trim().isEmpty) return CatalogSearch.empty;
      return ref.watch(catalogProvider).search(q.trim());
    });
