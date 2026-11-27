import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../features/playlist/playlist_edit.dart' show playlistProvider;
import '../../state/library.dart';
import '../../state/session.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'actions.dart';

/// Descobertas and Mistura da semana of this account (from the panel); null without a panel.
final mixesProvider = FutureProvider.autoDispose<(MixInfo, MixInfo)?>((
  ref,
) async {
  try {
    return await ref.watch(catalogProvider).mixes();
  } catch (_) {
    return null;
  }
});

/// Radar de Novidades, daylist and Blends of this account (from the panel); null without a panel.
final madeProvider = FutureProvider.autoDispose<MadeData?>((ref) async {
  try {
    return await ref.watch(catalogProvider).made();
  } catch (_) {
    return null;
  }
});

/// "descobertas" | "mistura" | "radar" | "daylist" by playlist name (null if it is none of them).
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

/// Radar / daylist this device asked the panel for and is still waiting on: the button spins
/// right away, before the panel reports it is running.
final madeWaitingProvider = NotifierProvider<MadeWaiting, Set<String>>(
  MadeWaiting.new,
);

class MadeWaiting extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};
  void set(String kind, bool on) =>
      state = on ? {...state, kind} : ({...state}..remove(kind));
}

/// Builds the Radar / daylist of this account now, follows the panel until it is done (the Radar
/// checks every followed artist and can take a minute or more) and then says what came out.
Future<void> runMade(BuildContext context, WidgetRef ref, String kind) async {
  // Lives on after the page closes: the wait outlasts it.
  final box = ProviderScope.containerOf(context, listen: false);
  final say = ScaffoldMessenger.maybeOf(context);
  final l = context.l10n;
  final waiting = box.read(madeWaitingProvider.notifier);
  if (box.read(madeWaitingProvider).contains(kind)) return;
  final cat = box.read(catalogProvider);
  void show(String msg, {int seconds = 2}) => say
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        width: 360,
        duration: Duration(seconds: seconds),
      ),
    );
  waiting.set(kind, true);
  try {
    await cat.runMade(kind);
    show(
      kind == 'radar'
          ? l.widgetMixSearchingReleases
          : l.widgetMixBuildingDaylist,
    );
    MadeInfo? info;
    final until = DateTime.now().add(const Duration(minutes: 10));
    while (DateTime.now().isBefore(until)) {
      await Future<void>.delayed(const Duration(seconds: 3));
      try {
        final m = await cat.made();
        info = kind == 'radar' ? m.radar : m.daylist;
        box.invalidate(madeProvider);
        if (!info.running) break;
      } catch (_) {
        // the panel did not answer this time: asks again
      }
    }
    box.invalidate(libraryProvider);
    final id = info?.playlist;
    if (id != null) box.invalidate(playlistProvider(id));
    if (info == null || info.running) return;
    final msg = madeResult(l, kind, info);
    if (msg != null) show(msg, seconds: 6);
  } catch (e) {
    show('$e');
  } finally {
    waiting.set(kind, false);
  }
}

/// What a finished Radar / daylist run says (null: nothing worth a message).
String? madeResult(L10n l, String kind, MadeInfo info) {
  final error = info.error;
  if (error != null && error.isNotEmpty) return l.widgetMixRadarFailed(error);
  if (kind != 'radar') return null;
  final albums = [
    for (final q in info.queued)
      for (final a in q.albums) '${q.artist} – $a',
  ];
  final note = info.note;
  return [
    l.widgetMixRadarDone(info.tracks),
    if (albums.isNotEmpty)
      l.widgetMixRadarQueued(
        albums.length,
        albums.length > 3 ? '${albums.take(3).join(', ')}…' : albums.join(', '),
      ),
    if (note != null && note.isNotEmpty) note,
  ].join('\n');
}

MixInfo mixInfo((MixInfo, MixInfo) m, String kind) =>
    kind == 'descobertas' ? m.$1 : m.$2;

/// Builds (or redoes) the Descobertas / Mistura da semana of this account.
Future<void> runMix(BuildContext context, WidgetRef ref, String kind) async {
  final desc = kind == 'descobertas';
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
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
    // The playlist appears or changes in Your Library within a few minutes.
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

/// Discreet "Redo" button on the playlist page, with the date of the last time.
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
    final running =
        info.running || ref.watch(madeWaitingProvider).contains(kind);
    return Tooltip(
      message: info.generated == null
          ? context.l10n.commonBuildNow
          : context.l10n.widgetMixBuiltOn(_date(info.generated!)),
      child: TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: Pm.subdued),
        icon: running
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh, size: 18),
        label: Text(
          running
              ? (kind == 'radar'
                    ? context.l10n.widgetMixSearchingReleases
                    : context.l10n.commonBuilding)
              : context.l10n.widgetMixRefresh,
        ),
        onPressed: running ? null : () => runMade(context, ref, kind),
      ),
    );
  }
}

/// Invitation to create Descobertas / Mistura when the account does not have one yet.
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
              running:
                  (kind == 'radar'
                      ? made!.radar.running
                      : made!.daylist.running) ||
                  ref.watch(madeWaitingProvider).contains(kind),
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
      side: BorderSide(color: Pm.muted),
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
      side: BorderSide(color: Pm.muted),
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
