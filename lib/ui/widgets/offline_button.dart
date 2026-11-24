import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../state/offline.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'actions.dart';

/// "Download" button of the pages (arrow in a circle, as in Spotify): stores the album/playlist on the device.
class OfflineButton extends ConsumerWidget {
  final String id; // collection id: album, playlist or "liked"
  final String name;
  final Item? head;
  final List<Item> tracks;
  const OfflineButton({
    super.key,
    required this.id,
    required this.name,
    required this.tracks,
    this.head,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(offlineProvider);
    final saved = st.saved(id);
    final ids = tracks.where((t) => !t.isCatalog).map((t) => t.id).toList();
    final done = ids.where(st.has).length;
    final busy = saved && done < ids.length;
    final notifier = ref.read(offlineProvider.notifier);
    return Tooltip(
      message: !saved
          ? context.l10n.commonDownloadToDevice
          : busy
          ? context.l10n.widgetOfflineDownloadingProgress(done, ids.length)
          : context.l10n.commonRemoveFromDevice,
      child: InkResponse(
        radius: 22,
        onTap: () async {
          if (saved) {
            await notifier.removeCollection(id);
            if (context.mounted) {
              toast(context, context.l10n.widgetActionsRemovedFromDevice);
            }
          } else {
            await notifier.saveCollection(id, name, head, tracks);
            if (context.mounted) {
              toast(context, context.l10n.widgetActionsDownloadingToDevice);
            }
          }
        },
        child: SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (busy)
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: ids.isEmpty ? null : done / ids.length,
                    strokeWidth: 2.5,
                    color: Pm.accent,
                    backgroundColor: Colors.white24,
                  ),
                ),
              Icon(
                saved && !busy
                    ? Icons.arrow_circle_down
                    : Icons.arrow_circle_down_outlined,
                size: busy ? 22 : 32,
                color: saved ? Pm.accent : Pm.subdued,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small green arrow next to the artist: the track is on the device.
class OfflineBadge extends ConsumerWidget {
  final String id;
  final double size;
  const OfflineBadge(this.id, {super.key, this.size = 14});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final has = ref.watch(offlineProvider.select((o) => o.has(id)));
    if (!has) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(Icons.arrow_circle_down, size: size, color: Pm.accent),
    );
  }
}
