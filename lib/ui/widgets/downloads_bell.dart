import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../state/downloads.dart';
import '../responsive.dart';
import '../theme.dart';
import 'disk_image.dart';
import '../../state/session.dart';
import 'actions.dart';

/// Sino: downloads pedidos pelo app (músicas, álbuns e discografias baixando para a biblioteca).
class DownloadsBell extends ConsumerWidget {
  const DownloadsBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    final st = ref.watch(downloadsProvider);
    final badge = st.active > 0 ? st.active : st.unseen;
    return IconButton(
      tooltip: st.active > 0 ? '${st.active} baixando' : 'Downloads',
      onPressed: () => _open(context, ref),
      icon: Badge(
        isLabelVisible: badge > 0,
        backgroundColor: st.active > 0 ? Pm.subdued : Pm.green,
        textColor: Colors.black,
        label: Text('$badge'),
        child: Icon(
          st.active > 0 ? Icons.downloading : Icons.notifications_none,
          color: Pm.subdued,
        ),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    ref.read(downloadsProvider.notifier)
      ..markSeen()
      ..refreshSoon();
    if (isCompact(context)) {
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        backgroundColor: Pm.elevated,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (sheet) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheet).height * 0.75,
          ),
          child: const SafeArea(child: DownloadsPanel()),
        ),
      );
      return;
    }
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.transparent,
      pageBuilder: (dctx, _, _) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 56, right: 72),
          child: Material(
            color: Pm.elevated,
            elevation: 12,
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox(
              width: 400,
              height: 480,
              child: DownloadsPanel(),
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadsPanel extends ConsumerWidget {
  const DownloadsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(downloadsProvider).jobs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Downloads',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        if (jobs.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Text(
              'Nada por aqui. Toque uma música com nuvem ou use "Baixar" no menu ⋯ '
              'para trazer do catálogo para a biblioteca.',
              style: TextStyle(color: Pm.subdued),
            ),
          )
        else
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 12),
              children: [for (final j in jobs) _JobTile(j)],
            ),
          ),
      ],
    );
  }
}

class _JobTile extends ConsumerWidget {
  final DownloadJob job;
  const _JobTile(this.job);

  Future<void> _act(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() fn,
    String done,
  ) async {
    try {
      await fn();
      ref.read(downloadsProvider.notifier).refreshSoon();
      if (context.mounted) toast(context, done);
    } catch (e) {
      if (context.mounted) toast(context, '$e');
    }
  }

  Future<void> _details(BuildContext context, WidgetRef ref) async {
    final cat = ref.read(catalogProvider);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Pm.elevated,
        title: Text(job.kind == 'artist' ? job.artist : job.title),
        content: SizedBox(
          width: 480,
          child: FutureBuilder<JobDetail>(
            future: cat.job(job.id),
            builder: (_, snap) {
              if (snap.hasError) return Text('${snap.error}');
              final d = snap.data;
              if (d == null) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (d.summary != null)
                      Text(d.summary!, style: const TextStyle(height: 1.4)),
                    if (d.summary == null && d.log.isNotEmpty) ...[
                      for (final l in d.log.reversed.take(12).toList().reversed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            l,
                            style: const TextStyle(
                              color: Pm.subdued,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final j = job;
    final cat = ref.read(catalogProvider);
    final what = switch (j.kind) {
      'album' => 'Álbum',
      'artist' => 'Discografia',
      'flac' => 'Em FLAC',
      'improve' => 'Qualidade',
      'albums' => 'Álbuns',
      'playlist' => 'Playlist',
      _ => 'Música',
    };
    final color = j.active
        ? Pm.subdued
        : (j.failed ? const Color(0xFFE57373) : Pm.green);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(j.kind == 'artist' ? 24 : 4),
        child: j.cover == null
            ? Container(width: 48, height: 48, color: Pm.highlight)
            : Image(
                image: DiskImage(
                  j.cover!.replaceFirst(RegExp(r'/\d+x\d+-'), '/120x120-'),
                ),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(width: 48, height: 48, color: Pm.highlight),
              ),
      ),
      title: Text(
        j.kind == 'artist' ? j.artist : j.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            j.kind == 'artist' ? what : '$what • ${j.artist}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Pm.subdued, fontSize: 12.5),
          ),
          Row(
            children: [
              if (j.active)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ),
              Expanded(
                child: Text(
                  j.statusLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
      // Controles discretos: só aparecem no ⋮.
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 18, color: Pm.muted),
        tooltip: 'Opções',
        color: Pm.elevated,
        onSelected: (v) => switch (v) {
          'details' => _details(context, ref),
          'cancel' => _act(
            context,
            ref,
            () => cat.cancelJob(j.id),
            'Download cancelado',
          ),
          'retry' => _act(
            context,
            ref,
            () => cat.retryJob(j.id),
            'Tentando de novo',
          ),
          _ => _act(
            context,
            ref,
            () => cat.deleteJob(j.id),
            'Removido da lista',
          ),
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'details', child: Text('Ver detalhes')),
          if (j.active)
            const PopupMenuItem(value: 'cancel', child: Text('Cancelar')),
          if (!j.active && !j.ok)
            const PopupMenuItem(value: 'retry', child: Text('Tentar de novo')),
          if (!j.active)
            const PopupMenuItem(
              value: 'delete',
              child: Text('Remover da lista'),
            ),
        ],
      ),
    );
  }
}
