import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/updater.dart';
import '../theme.dart';
import 'actions.dart';

/// Faixa discreta "Nova versão do Pudim" quando a atualização já foi baixada.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final u = ref.watch(updaterProvider);
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: u == null
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 2, 4, 2),
              color: const Color(0xFF1B3A26),
              child: Row(
                children: [
                  const Icon(Icons.system_update, size: 16, color: Pm.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      u.notes.isEmpty
                          ? 'Nova versão do Pudim pronta'
                          : 'Nova versão do Pudim · ${u.notes}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Pm.text, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Pm.green,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () async {
                      final err = await ref
                          .read(updaterProvider.notifier)
                          .install();
                      if (err != null && context.mounted) toast(context, err);
                    },
                    child: const Text(
                      'Atualizar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
