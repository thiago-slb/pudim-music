import 'package:material_ui/material_ui.dart';

import '../../api/response_cache.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';

/// "No internet" strip while the server does not answer (screens come from the device).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = ResponseCache.instance;
    if (cache == null) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: cache.offline,
      builder: (_, off, _) => AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: !off
            ? const SizedBox(width: double.infinity)
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 12,
                ),
                color: const Color(0xFF2A2A2A),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 15, color: Pm.subdued),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        context.l10n.widgetOfflineBanner,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Pm.subdued, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
