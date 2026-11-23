import 'package:material_ui/material_ui.dart';

import '../../api/response_cache.dart';
import '../theme.dart';

/// Faixa "Sem internet" enquanto o servidor não responde (as telas vêm do aparelho).
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 15, color: Pm.subdued),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Sem internet · mostrando o que está guardado no aparelho',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Pm.subdued, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
