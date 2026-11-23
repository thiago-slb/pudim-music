import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../theme.dart';

/// Troca de conta/servidor: a fila é da biblioteca da conta de antes, então para e esvazia.
Future<void> switchAccount(WidgetRef ref, String id) async {
  await ref.read(playerProvider.notifier).stop();
  await ref.read(sessionProvider.notifier).switchTo(id);
}

/// Vai para a tela de entrar sem sair da conta atual (dá para voltar).
Future<void> addAccount(WidgetRef ref) async {
  await ref.read(playerProvider.notifier).stop();
  ref.read(sessionProvider.notifier).beginAdd();
}

/// Lista das contas salvas (Configurações): a em uso marcada, as outras com "Trocar".
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
              backgroundColor: a.id == active ? Pm.green : Pm.elevated,
              foregroundColor: a.id == active ? Colors.black : Pm.text,
              child: Text(
                a.userName.isEmpty ? '?' : a.userName[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            title: Text(a.userName),
            subtitle: Text(a.host, style: const TextStyle(color: Pm.subdued)),
            trailing: a.id == active
                ? Text(l.accountsInUse, style: const TextStyle(color: Pm.green))
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Pm.text,
                      side: const BorderSide(color: Pm.muted),
                      shape: const StadiumBorder(),
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
