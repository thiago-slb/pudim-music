import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors.dart';
import '../theme.dart';
import 'theme_bits.dart';
import 'themed.dart';

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
                colors: pageGradient(c),
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
        final row = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _coverFrame(cover, size, 60),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeLabel(type),
                  const SizedBox(height: 8),
                  pageTitle(title, fs),
                  const SizedBox(height: 12),
                  if (description != null) ...[
                    DefaultTextStyle.merge(
                      style: TextStyle(color: Pm.subdued, fontSize: 14),
                      child: description!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  DefaultTextStyle.merge(
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
        );
        // Retro: the whole header sits in a raised gray window.
        if (Pm.current.style == UiStyle.retro) {
          return ThemedPanel(
            margin: const EdgeInsets.fromLTRB(24, 56, 24, 16),
            child: row,
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          child: row,
        );
      },
    );
  }
}

/// Cover framed in the theme's way: deep shadow, bevel, colored glow or square and flat.
Widget _coverFrame(Widget cover, double size, double blur) {
  final t = Pm.current;
  final img = SizedBox(
    width: size,
    height: size,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(t.coverRadius),
      child: FittedBox(fit: BoxFit.cover, child: cover),
    ),
  );
  return switch (t.style) {
    UiStyle.retro => Container(
      padding: const EdgeInsets.all(4),
      decoration: bevel(pressed: true),
      child: img,
    ),
    UiStyle.ruby => img,
    UiStyle.glass => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.coverRadius),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(color: t.accent.withValues(alpha: 0.55), blurRadius: blur),
        ],
      ),
      child: img,
    ),
    UiStyle.wave => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.coverRadius),
        boxShadow: [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.5),
            blurRadius: blur,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: img,
    ),
    UiStyle.night => DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: blur,
            color: Colors.black54,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: img,
    ),
  };
}

/// Page title: huge and heavy (night, wave), plainer (ruby), LCD text (retro), glowing (glass).
Widget pageTitle(
  String title,
  double fs, {
  bool compact = false,
  int maxLines = 2,
}) {
  final t = Pm.current;
  final style = switch (t.style) {
    UiStyle.retro => TextStyle(
      fontSize: compact ? 18 : (fs * 0.45).clamp(18, 34),
      color: t.accent,
      letterSpacing: 1,
      height: 1.2,
    ),
    UiStyle.ruby => TextStyle(
      fontSize: compact ? 26 : (fs * 0.55).clamp(26, 44),
      fontWeight: FontWeight.w700,
      height: 1.15,
    ),
    UiStyle.wave => TextStyle(
      fontSize: compact ? 30 : fs * 1.05,
      fontWeight: FontWeight.w900,
      letterSpacing: compact ? -1 : -2.5,
      height: 1.0,
    ),
    UiStyle.glass => TextStyle(
      fontSize: compact ? 24 : fs * 0.8,
      fontWeight: FontWeight.w800,
      height: 1.1,
      shadows: [Shadow(color: t.accent.withValues(alpha: 0.8), blurRadius: 18)],
    ),
    UiStyle.night => TextStyle(
      fontSize: compact ? 24 : fs,
      height: compact ? 1.15 : 1.05,
      fontWeight: compact ? FontWeight.w800 : FontWeight.w900,
      letterSpacing: compact ? null : -1.5,
    ),
  };
  final text = Text(
    t.style == UiStyle.retro ? title.toUpperCase() : title,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: style,
  );
  if (t.style != UiStyle.retro) return text;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: bevel(pressed: true, color: Colors.black),
    child: text,
  );
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
            child: _coverFrame(
              cover,
              Pm.current.style == UiStyle.ruby ? width - 32 : size,
              40,
            ),
          ),
          const SizedBox(height: 20),
          if (Pm.current.style != UiStyle.night) ...[
            TypeLabel(type),
            const SizedBox(height: 8),
          ],
          pageTitle(title, 24, compact: true),
          const SizedBox(height: 6),
          if (description != null) ...[
            DefaultTextStyle.merge(
              style: TextStyle(color: Pm.subdued, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              child: description!,
            ),
            const SizedBox(height: 6),
          ],
          DefaultTextStyle.merge(
            style: TextStyle(color: Pm.subdued, fontSize: 13),
            child: Row(
              children: [
                if (Pm.current.style == UiStyle.night)
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
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final t = Pm.current;
    // Retro: a raised toolbar of keys; glass: a glossy strip; ruby: flat.
    if (t.style == UiStyle.retro || t.style == UiStyle.glass) {
      return Container(
        margin: EdgeInsets.fromLTRB(narrow ? 12 : 24, 8, narrow ? 12 : 24, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: panelDecoration(),
        child: Row(children: children),
      );
    }
    return Container(
      decoration: t.style == UiStyle.ruby
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
      padding: narrow
          ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
          : const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(children: children),
    );
  }
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
