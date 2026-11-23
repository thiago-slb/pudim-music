import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import '../api/models.dart';
import 'library.dart';
import 'session.dart';
import 'notify.dart';

class DownloadsState {
  final List<DownloadJob> jobs;

  /// Quantos terminaram desde a última vez que o sino foi aberto.
  final int unseen;
  const DownloadsState({this.jobs = const [], this.unseen = 0});

  int get active => jobs.where((j) => j.active).length;
}

/// Downloads pedidos pelo app (sino). Consulta o painel a cada 5 s enquanto tem algo baixando e a cada
/// 60 s quando está tudo parado (sem SSE: ver painel/player_api.py).
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

  /// Algo acabou de ser pedido: olha logo (o job aparece em ~1 s).
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
      // Chegou música nova: a biblioteca e a busca passam a mostrar ✓.
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

  /// Como no Spotify: notificação fixa enquanto baixa e um aviso quando chega.
  void _notifyJobs(Map<String, DownloadJob> before, List<DownloadJob> jobs) {
    final active = jobs.where((j) => j.active).toList();
    if (active.isEmpty) {
      Notify.cancel(Notify.libraryId);
    } else {
      final first = active.first;
      Notify.progress(
        Notify.libraryId,
        active.length == 1
            ? 'Baixando ${_name(first)}'
            : 'Baixando ${active.length} pedidos',
        active.length == 1
            ? first.statusLabel
            : active.map(_name).take(3).join(', '),
      );
    }
    // Primeira consulta: não avisa do que já tinha terminado.
    if (before.isEmpty) return;
    for (final j in jobs) {
      final was = before[j.id];
      if (was == null || !was.active || j.active) continue;
      final title = j.ok
          ? '${_name(j)} chegou na biblioteca'
          : j.status == 'parcial'
          ? '${_name(j)} chegou em parte'
          : '${_name(j)}: ${j.statusLabel.toLowerCase()}';
      Notify.show(j.id.hashCode & 0x7fffffff, title, j.summary ?? '');
    }
  }

  /// Avisos do servidor (lançamento de quem você segue, Descobertas, Mistura, playlist completa).
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
      // Primeira vez: só marca o agora (não despeja o histórico).
      final last = list.isEmpty ? serverNow : list.last.ts;
      await prefs.setDouble('noticeSince', since == null ? serverNow : last);
    } catch (_) {}
  }

  void markSeen() {
    _seen = DateTime.now();
    state = DownloadsState(jobs: state.jobs, unseen: 0);
  }

  /// Pede o download (track | album | artist) de um item do catálogo. Devolve o texto do aviso.
  Future<String> request(String kind, Item it) async {
    final n = switch (kind) {
      'album' => catalogNumber(it.kind == ItemKind.album ? it.id : it.albumId),
      'artist' => catalogNumber(
        it.kind == ItemKind.artist ? it.id : it.mainArtist?.id,
      ),
      _ => it.deezerId,
    };
    if (n == null) return 'Esse item não veio do catálogo.';
    try {
      final again = await ref.read(catalogProvider).download(kind, n);
      refreshSoon();
      final what = switch (kind) {
        'album' => 'o álbum',
        'artist' => 'a discografia',
        _ => 'a música',
      };
      return again
          ? 'Já está baixando $what.'
          : 'Baixando $what. Aparece no sino quando chegar.';
    } on CatalogException catch (e) {
      return e.message;
    }
  }
}

final downloadsProvider = NotifierProvider<DownloadsNotifier, DownloadsState>(
  DownloadsNotifier.new,
);

/// Busca no catálogo do painel (o app junta com a da biblioteca na página de busca).
final catalogSearchProvider = FutureProvider.autoDispose
    .family<CatalogSearch, String>((ref, q) async {
      if (q.trim().isEmpty) return CatalogSearch.empty;
      return ref.watch(catalogProvider).search(q.trim());
    });
