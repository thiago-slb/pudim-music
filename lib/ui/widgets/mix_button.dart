import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../state/library.dart';
import '../../state/session.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'actions.dart';

/// Descobertas e Mistura da semana desta conta (do painel); null sem painel.
final mixesProvider = FutureProvider.autoDispose<(MixInfo, MixInfo)?>((
  ref,
) async {
  try {
    return await ref.watch(catalogProvider).mixes();
  } catch (_) {
    return null;
  }
});

/// Radar de Novidades, daylist e Blends desta conta (do painel); null sem painel.
final madeProvider = FutureProvider.autoDispose<MadeData?>((ref) async {
  try {
    return await ref.watch(catalogProvider).made();
  } catch (_) {
    return null;
  }
});

/// "descobertas" | "mistura" | "radar" | "daylist" pelo nome da playlist (null se não for uma delas).
String? mixKindOf(String playlistName) =>
    playlistName.startsWith('Descobertas da semana')
    ? 'descobertas'
    : playlistName == 'Mistura da semana'
    ? 'mistura'
    : playlistName == 'Radar de Novidades'
    ? 'radar'
    : playlistName.startsWith('daylist · ')
    ? 'daylist'
    : null;

/// Monta agora o Radar / a daylist desta conta.
Future<void> runMade(BuildContext context, WidgetRef ref, String kind) async {
  try {
    await ref.read(catalogProvider).runMade(kind);
    if (context.mounted) {
      toast(
        context,
        kind == 'radar'
            ? context.l10n.widgetMixSearchingReleases
            : context.l10n.widgetMixBuildingDaylist,
      );
    }
    ref.invalidate(madeProvider);
    for (final s in const [8, 25, 60]) {
      Timer(Duration(seconds: s), () {
        try {
          ref.invalidate(madeProvider);
          ref.invalidate(libraryProvider);
        } catch (_) {}
      });
    }
  } catch (e) {
    if (context.mounted) toast(context, '$e');
  }
}

MixInfo mixInfo((MixInfo, MixInfo) m, String kind) =>
    kind == 'descobertas' ? m.$1 : m.$2;

/// Monta (ou refaz) as Descobertas / a Mistura da semana desta conta.
Future<void> runMix(BuildContext context, WidgetRef ref, String kind) async {
  final desc = kind == 'descobertas';
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Pm.elevated,
      title: Text(
        desc
            ? ctx.l10n.widgetMixNewDiscoveriesTitle
            : ctx.l10n.widgetMixNewMixTitle,
      ),
      content: Text(
        desc
            ? ctx.l10n.widgetMixNewDiscoveriesBody
            : ctx.l10n.widgetMixNewMixBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.l10n.widgetMixNotNow),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ctx.l10n.commonBuildNow),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  try {
    await ref.read(catalogProvider).runMix(kind);
    if (context.mounted) {
      toast(
        context,
        desc
            ? context.l10n.widgetMixBuildingDiscoveries
            : context.l10n.widgetMixBuildingMix,
      );
    }
    ref.invalidate(mixesProvider);
    // A playlist aparece ou muda na Sua Biblioteca em alguns minutos.
    for (final s in const [20, 60, 180]) {
      Timer(Duration(seconds: s), () {
        try {
          ref.invalidate(libraryProvider);
          ref.invalidate(mixesProvider);
        } catch (_) {}
      });
    }
  } catch (e) {
    if (context.mounted) toast(context, '$e');
  }
}

String _date(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

/// Botão discreto "Refazer" na página da playlist, com a data da última vez.
class MixButton extends ConsumerWidget {
  final String kind;
  const MixButton(this.kind, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kind == 'radar' || kind == 'daylist') return _made(context, ref);
    final m = ref.watch(mixesProvider).value;
    if (m == null) return const SizedBox.shrink();
    final info = mixInfo(m, kind);
    if (!info.available) return const SizedBox.shrink();
    return Tooltip(
      message: info.generated == null
          ? context.l10n.commonBuildNow
          : context.l10n.widgetMixBuiltOn(_date(info.generated!)),
      child: TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: Pm.subdued),
        icon: info.running
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh, size: 18),
        label: Text(
          info.running
              ? context.l10n.commonBuilding
              : context.l10n.widgetMixRedo,
        ),
        onPressed: info.running ? null : () => runMix(context, ref, kind),
      ),
    );
  }
}

extension on MixButton {
  Widget _made(BuildContext context, WidgetRef ref) {
    final m = ref.watch(madeProvider).value;
    if (m == null) return const SizedBox.shrink();
    final info = kind == 'radar' ? m.radar : m.daylist;
    return Tooltip(
      message: info.generated == null
          ? context.l10n.commonBuildNow
          : context.l10n.widgetMixBuiltOn(_date(info.generated!)),
      child: TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: Pm.subdued),
        icon: info.running
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh, size: 18),
        label: Text(
          info.running
              ? context.l10n.commonBuilding
              : context.l10n.widgetMixRefresh,
        ),
        onPressed: info.running ? null : () => runMade(context, ref, kind),
      ),
    );
  }
}

/// Convite para criar as Descobertas / a Mistura quando a conta ainda não tem.
class MixInvites extends ConsumerWidget {
  final List<String> playlistNames;
  const MixInvites({super.key, required this.playlistNames});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    final m = ref.watch(mixesProvider).value;
    final made = ref.watch(madeProvider).value;
    if (m == null) return const SizedBox.shrink();
    bool has(String kind) => playlistNames.any((n) => mixKindOf(n) == kind);
    final kinds = <String>[
      if (!has('descobertas')) 'descobertas',
      if (m.$2.available && !has('mistura')) 'mistura',
    ];
    final madeKinds = <String>[
      if (made != null && !has('daylist')) 'daylist',
      if (made != null && !has('radar') && made.radar.note == null) 'radar',
    ];
    if (kinds.isEmpty && madeKinds.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final kind in kinds) _Invite(kind: kind, info: mixInfo(m, kind)),
          for (final kind in madeKinds)
            _MadeInvite(
              kind: kind,
              running: kind == 'radar'
                  ? made!.radar.running
                  : made!.daylist.running,
            ),
        ],
      ),
    );
  }
}

class _Invite extends ConsumerWidget {
  final String kind;
  final MixInfo info;
  const _Invite({required this.kind, required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: Pm.text,
      side: const BorderSide(color: Pm.muted),
      shape: const StadiumBorder(),
    ),
    icon: info.running
        ? const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.auto_awesome, size: 18),
    label: Text(
      info.running
          ? context.l10n.commonBuilding
          : kind == 'descobertas'
          ? context.l10n.widgetMixCreateDiscoveries
          : context.l10n.widgetMixCreateMix,
    ),
    onPressed: info.running ? null : () => runMix(context, ref, kind),
  );
}

class _MadeInvite extends ConsumerWidget {
  final String kind;
  final bool running;
  const _MadeInvite({required this.kind, required this.running});

  @override
  Widget build(BuildContext context, WidgetRef ref) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: Pm.text,
      side: const BorderSide(color: Pm.muted),
      shape: const StadiumBorder(),
    ),
    icon: running
        ? const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(kind == 'radar' ? Icons.radar : Icons.wb_twilight, size: 18),
    label: Text(
      running
          ? context.l10n.commonBuilding
          : kind == 'radar'
          ? context.l10n.widgetMixCreateRadar
          : context.l10n.widgetMixCreateDaylist,
    ),
    onPressed: running ? null : () => runMade(context, ref, kind),
  );
}
