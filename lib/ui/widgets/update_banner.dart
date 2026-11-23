import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/updater.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'actions.dart';

/// Builds already offered in a dialog (both shells share it; once per build is enough).
final _asked = <int>{};

/// Discreet "New version of Pudim" strip when the update has already been downloaded.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final u = ref.watch(updaterProvider);
    // Ready: ask once right away instead of waiting for someone to notice the strip.
    ref.listen(updaterProvider, (prev, next) {
      if (next == null ||
          prev?.build == next.build ||
          _asked.contains(next.build)) {
        return;
      }
      _asked.add(next.build);
      showDialog<void>(
        context: context,
        useRootNavigator: true,
        builder: (d) => AlertDialog(
          backgroundColor: Pm.elevated,
          title: Text(d.l10n.widgetUpdateReady),
          content: next.notes.isEmpty ? null : Text(next.notes),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: Text(d.l10n.commonClose),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(d).pop();
                final err = await ref.read(updaterProvider.notifier).install();
                if (err != null && context.mounted) toast(context, err);
              },
              child: Text(d.l10n.widgetUpdateAction),
            ),
          ],
        ),
      );
    });
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
                          ? context.l10n.widgetUpdateReady
                          : context.l10n.widgetUpdateReadyNotes(u.notes),
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
                    child: Text(
                      context.l10n.widgetUpdateAction,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
