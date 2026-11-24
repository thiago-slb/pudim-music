import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../theme.dart';

/// Account/server switch: the queue belongs to the previous account library, so it stops and is emptied.
Future<void> switchAccount(WidgetRef ref, String id) async {
  await ref.read(playerProvider.notifier).stop();
  await ref.read(sessionProvider.notifier).switchTo(id);
}

/// Goes to the sign-in screen without leaving the current account (can go back).
Future<void> addAccount(WidgetRef ref) async {
  await ref.read(playerProvider.notifier).stop();
  ref.read(sessionProvider.notifier).beginAdd();
}

/// List of saved accounts (Settings): the one in use marked, the others with "Switch".
class AccountsList extends ConsumerWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sessionProvider);
    final n = ref.read(sessionProvider.notifier);
    final l = context.l10n;
    final active = n.activeId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in n.accounts)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: a.id == active ? Pm.accent : Pm.elevated,
              foregroundColor: a.id == active ? Pm.onAccent : Pm.text,
              child: Text(
                a.userName.isEmpty ? '?' : a.userName[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            title: Text(a.userName),
            subtitle: Text(a.host, style: TextStyle(color: Pm.subdued)),
            trailing: a.id == active
                ? Text(l.accountsInUse, style: TextStyle(color: Pm.accent))
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Pm.text,
                      side: BorderSide(color: Pm.muted),
                    ),
                    onPressed: () => switchAccount(ref, a.id),
                    child: Text(l.accountsSwitch),
                  ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Pm.text),
            onPressed: () => addAccount(ref),
            icon: const Icon(Icons.add),
            label: Text(l.accountsAdd),
          ),
        ),
      ],
    );
  }
}
