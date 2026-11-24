import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cast/cast_controller.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'actions.dart';

/// Cast button (Chromecast). Green when the sound is coming out on another device.
class CastButton extends ConsumerWidget {
  final double size;
  const CastButton({super.key, this.size = 18});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(castProvider);
    final l = context.l10n;
    final on = s.device != null;
    return IconButton(
      tooltip: s.active ? l.castPlayingOn(s.device!.name) : l.castTooltip,
      onPressed: () => showCastSheet(context, ref),
      icon: Icon(
        on ? Icons.cast_connected : Icons.cast,
        size: size,
        color: on ? Pm.accent : Pm.subdued,
      ),
    );
  }
}

Future<void> showCastSheet(BuildContext context, WidgetRef ref) async {
  final c = ref.read(castProvider.notifier);
  if (ref.read(castProvider).device == null) c.search();
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Pm.elevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const _CastSheet(),
  );
}

class _CastSheet extends ConsumerWidget {
  const _CastSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(castProvider);
    final c = ref.read(castProvider.notifier);
    final l = context.l10n;
    ref.listen(castProvider.select((s) => s.error), (_, err) {
      if (err != null) toast(context, l.castFailed(err));
    });
    final current = s.device;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                l.castTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.smartphone,
                color: current == null ? Pm.accent : Pm.subdued,
              ),
              title: Text(
                l.castThisDevice,
                style: TextStyle(color: current == null ? Pm.accent : null),
              ),
              onTap: () {
                Navigator.pop(context);
                if (current != null) c.disconnect();
              },
            ),
            for (final d in s.devices)
              ListTile(
                leading: Icon(
                  current?.serviceName == d.serviceName
                      ? Icons.cast_connected
                      : Icons.cast,
                  color: current?.serviceName == d.serviceName
                      ? Pm.accent
                      : Pm.subdued,
                ),
                title: Text(
                  d.name,
                  style: TextStyle(
                    color: current?.serviceName == d.serviceName
                        ? Pm.accent
                        : null,
                  ),
                ),
                subtitle: d.extras['md'] == null ? null : Text(d.extras['md']!),
                trailing: current?.serviceName == d.serviceName && s.connecting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: current?.serviceName == d.serviceName
                    ? null
                    : () {
                        Navigator.pop(context);
                        c.connect(d);
                      },
              ),
            if (s.searching)
              ListTile(
                leading: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                title: Text(l.castSearching),
              )
            else ...[
              if (s.devices.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                  child: Text(l.castNone, style: TextStyle(color: Pm.subdued)),
                ),
              ListTile(
                leading: Icon(Icons.refresh, color: Pm.subdued),
                title: Text(l.castSearchAgain),
                onTap: c.search,
              ),
            ],
            if (current != null)
              ListTile(
                leading: Icon(Icons.cast, color: Pm.subdued),
                title: Text(l.castStop),
                onTap: () {
                  Navigator.pop(context);
                  c.disconnect();
                },
              ),
          ],
        ),
      ),
    );
  }
}
