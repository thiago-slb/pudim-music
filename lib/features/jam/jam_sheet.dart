import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/jam.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/user_photo.dart';
import '../chat/chat_pages.dart';

/// Ícone da Jam no player (verde com o número de pessoas quando está numa).
class JamButton extends ConsumerWidget {
  final double size;
  const JamButton({super.key, this.size = 18});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    final jam = ref.watch(jamProvider);
    final n = jam?.members.length ?? 0;
    return IconButton(
      tooltip: jam == null ? context.l10n.jamStart : context.l10n.jamTooltip(n),
      onPressed: () => showJamSheet(context),
      icon: Badge(
        isLabelVisible: jam != null,
        backgroundColor: Pm.green,
        textColor: Colors.black,
        label: Text('$n'),
        child: Icon(
          Icons.groups_outlined,
          size: size,
          color: jam != null ? Pm.green : Pm.subdued,
        ),
      ),
    );
  }
}

Future<void> showJamSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: Pm.elevated,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) => const _JamSheet(),
);

class _JamSheet extends ConsumerStatefulWidget {
  const _JamSheet();
  @override
  ConsumerState<_JamSheet> createState() => _JamSheetState();
}

class _JamSheetState extends ConsumerState<_JamSheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() f) async {
    setState(() => _busy = true);
    try {
      await f();
    } catch (e) {
      if (mounted) toast(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final jam = ref.watch(jamProvider);
    final me = ref.watch(sessionProvider).value?.userId;
    final ctl = ref.read(jamProvider.notifier);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF1ED760)],
                    ),
                  ),
                  child: const Icon(Icons.groups_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jam',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        jam == null
                            ? context.l10n.jamSubIdle
                            : jam.isHost
                            ? context.l10n.jamSubHost
                            : context.l10n.jamSubGuest,
                        style: const TextStyle(color: Pm.subdued),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (jam == null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(context.l10n.jamStart),
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                          if (ref.read(playerProvider).current == null) {
                            throw CatalogException(context.l10n.jamPlayFirst);
                          }
                          await ctl.start();
                        }),
                ),
              ),
            ] else ...[
              Text(
                context.l10n.jamMembers(jam.members.length),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Pm.subdued,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              for (final m in jam.members)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      UserPhoto(
                        userId: m.id,
                        name: m.displayName,
                        tag: m.image,
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          m.id == me
                              ? context.l10n.jamYouSuffix(m.displayName)
                              : m.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (m.id == jam.host)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Pm.highlight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            context.l10n.jamHost,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Pm.text,
                        side: const BorderSide(color: Pm.muted),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.person_add_alt, size: 18),
                      label: Text(context.l10n.jamInvite),
                      onPressed: _busy
                          ? null
                          : () async {
                              final c = await pickContact(
                                context,
                                title: context.l10n.jamInviteTitle,
                                subtitle: context.l10n.jamInviteSubtitle,
                              );
                              if (c == null) return;
                              await _run(() async {
                                await ctl.invite(c.id);
                                if (context.mounted) {
                                  toast(
                                    context,
                                    context.l10n.jamInviteSent(c.displayName),
                                  );
                                }
                              });
                            },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Pm.highlight,
                        foregroundColor: Pm.text,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _busy
                          ? null
                          : () => _run(() async {
                              await ctl.leave();
                              if (context.mounted) Navigator.pop(context);
                            }),
                      child: Text(
                        jam.isHost
                            ? context.l10n.jamEnd
                            : context.l10n.jamLeave,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
