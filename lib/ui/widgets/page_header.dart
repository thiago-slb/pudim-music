import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors.dart';
import '../theme.dart';

/// Page with a gradient background in the cover color, as in Spotify.
class GradientPage extends ConsumerWidget {
  final String? colorFromUrl;
  final Color? color;
  final List<Widget> children;
  const GradientPage({
    super.key,
    this.colorFromUrl,
    this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c =
        color ??
        (colorFromUrl == null
            ? fallbackColor
            : ref.watch(coverColorProvider(colorFromUrl!)).value ??
                  fallbackColor);
    return Container(
      color: Pm.base,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 520,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [c, darken(c, 0.12).withValues(alpha: 0.6), Pm.base],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
          ListView(padding: EdgeInsets.zero, children: children),
        ],
      ),
    );
  }
}

/// Large header: cover + "Playlist"/"Album" + huge title + details line.
class BigHeader extends StatelessWidget {
  final Widget cover;
  final String type;
  final String title;
  final Widget? description;
  final Widget meta;
  const BigHeader({
    super.key,
    required this.cover,
    required this.type,
    required this.title,
    required this.meta,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 600) return _compact(c.maxWidth);
        final size = c.maxWidth > 900 ? 232.0 : 192.0;
        final fs = title.length > 30
            ? 40.0
            : title.length > 18
            ? 56.0
            : (c.maxWidth > 900 ? 88.0 : 64.0);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 60,
                        color: Colors.black54,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FittedBox(child: cover),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fs,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (description != null) ...[
                      DefaultTextStyle(
                        style: TextStyle(color: Pm.subdued, fontSize: 14),
                        child: description!,
                      ),
                      const SizedBox(height: 8),
                    ],
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      child: meta,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on BigHeader {
  /// Phone: centered cover and title below, left-aligned.
  Widget _compact(double width) {
    final size = (width * 0.62).clamp(160.0, 280.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 40,
                      color: Colors.black54,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: FittedBox(child: cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          if (description != null) ...[
            DefaultTextStyle(
              style: TextStyle(color: Pm.subdued, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              child: description!,
            ),
            const SizedBox(height: 6),
          ],
          DefaultTextStyle(
            style: TextStyle(color: Pm.subdued, fontSize: 13),
            child: Row(
              children: [
                Text(
                  '$type • ',
                  style: TextStyle(color: Pm.subdued, fontSize: 13),
                ),
                Flexible(child: meta),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark strip below the header where the green play and the actions live.
class ActionBar extends StatelessWidget {
  final List<Widget> children;
  const ActionBar({super.key, required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black.withValues(alpha: 0.25), Colors.transparent],
      ),
    ),
    padding: MediaQuery.sizeOf(context).width < 600
        ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
        : const EdgeInsets.fromLTRB(24, 24, 24, 16),
    child: Row(children: children),
  );
}

/// Page body with the standard side padding.
class PageBody extends StatelessWidget {
  final Widget child;
  const PageBody({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Padding(
    padding: MediaQuery.sizeOf(context).width < 600
        ? const EdgeInsets.fromLTRB(4, 0, 4, 32)
        : const EdgeInsets.fromLTRB(24, 0, 24, 48),
    child: child,
  );
}
