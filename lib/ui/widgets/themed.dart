import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'theme_bits.dart';

/// Shared pieces for the inner pages (headers, panels, sheets, dialogs, loading, empty states):
/// each one reads the theme in use so the pages themselves keep no fixed style.

const _bevelLight = Color(0xFF8A8A98), _bevelDark = Color(0xFF0E0E12);

/// Raised 3D edge as a shape, for dialogs, sheets, menus and toasts (retro).
class BevelBorder extends OutlinedBorder {
  final bool pressed;
  const BevelBorder({this.pressed = false, super.side});

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(2);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect.deflate(2));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final hi = Paint()..color = pressed ? _bevelDark : _bevelLight;
    final lo = Paint()..color = pressed ? _bevelLight : _bevelDark;
    canvas
      ..drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, 2), hi)
      ..drawRect(Rect.fromLTWH(rect.left, rect.top, 2, rect.height), hi)
      ..drawRect(Rect.fromLTWH(rect.left, rect.bottom - 2, rect.width, 2), lo)
      ..drawRect(Rect.fromLTWH(rect.right - 2, rect.top, 2, rect.height), lo);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  BevelBorder copyWith({BorderSide? side}) =>
      BevelBorder(pressed: pressed, side: side ?? this.side);
}

/// Outline of floating surfaces (dialogs, sheets, menus, toasts) in the theme in use.
ShapeBorder surfaceShape([AppTheme? theme, double? big]) {
  final t = theme ?? Pm.current;
  return switch (t.style) {
    UiStyle.retro => const BevelBorder(),
    UiStyle.ruby => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(big == null ? 2 : 12),
    ),
    UiStyle.wave => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(big ?? 18),
    ),
    UiStyle.glass => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(big == null ? 8 : 14),
      side: BorderSide(color: t.accent.withValues(alpha: 0.55)),
    ),
    UiStyle.night => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(big ?? 8),
    ),
  };
}

/// Bottom sheet outline: rounded top only, except the retro bevel.
ShapeBorder sheetShape([AppTheme? theme]) {
  final t = theme ?? Pm.current;
  final r = switch (t.style) {
    UiStyle.retro => 0.0,
    UiStyle.ruby => 12.0,
    UiStyle.wave => 28.0,
    UiStyle.glass => 16.0,
    UiStyle.night => 12.0,
  };
  if (t.style == UiStyle.retro) return const BevelBorder();
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(r)),
    side: t.style == UiStyle.glass
        ? BorderSide(color: t.accent.withValues(alpha: 0.55))
        : BorderSide.none,
  );
}

/// Box behind a group of controls (settings sections, empty states, header details).
BoxDecoration panelDecoration({bool strong = false}) {
  final t = Pm.current;
  return switch (t.style) {
    UiStyle.retro => bevel(),
    UiStyle.glass => BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [t.press, t.elevated, t.black],
        stops: const [0, 0.5, 1],
      ),
      border: Border.all(color: t.accent.withValues(alpha: 0.45)),
    ),
    UiStyle.wave => BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          t.accent.withValues(alpha: strong ? 0.45 : 0.22),
          t.elevated,
        ],
      ),
    ),
    UiStyle.ruby => BoxDecoration(
      color: t.elevated,
      borderRadius: BorderRadius.circular(12),
    ),
    UiStyle.night => BoxDecoration(
      color: t.elevated,
      borderRadius: BorderRadius.circular(8),
    ),
  };
}

/// [panelDecoration] around [child].
class ThemedPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool strong;
  const ThemedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    padding: padding,
    decoration: panelDecoration(strong: strong),
    clipBehavior: Pm.current.style == UiStyle.retro
        ? Clip.none
        : Clip.antiAlias,
    child: child,
  );
}

/// Small label above a page title ("Album", "Playlist"): plain text, a pill or an LCD tag.
class TypeLabel extends StatelessWidget {
  final String text;
  const TypeLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    switch (t.style) {
      case UiStyle.retro:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          color: Colors.black,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(color: t.accent, fontSize: 12, letterSpacing: 1.5),
          ),
        );
      case UiStyle.wave:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [t.accent, t.accent.withValues(alpha: 0.5)],
            ),
          ),
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: t.onAccent,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        );
      case UiStyle.ruby:
        return Text(
          text,
          style: TextStyle(
            color: t.subdued,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      case UiStyle.glass:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: glass(radius: BorderRadius.circular(10))
              .copyWith(boxShadow: const []),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      case UiStyle.night:
        return Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        );
    }
  }
}

/// Spinner in the theme's language: LCD bars (retro), a thin bar (ruby), a glowing ring (glass).
class ThemedLoading extends StatelessWidget {
  final double size;
  const ThemedLoading({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    switch (t.style) {
      case UiStyle.retro:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: bevel(pressed: true, color: Colors.black),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LevelBars(playing: true),
              const SizedBox(width: 8),
              Text(
                'LOADING',
                style: TextStyle(
                  color: t.accent,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      case UiStyle.ruby:
        return SizedBox(
          width: size * 4,
          child: LinearProgressIndicator(
            minHeight: 3,
            color: t.accent,
            backgroundColor: t.highlight,
          ),
        );
      case UiStyle.glass:
        return Container(
          width: size + 12,
          height: size + 12,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: t.accent.withValues(alpha: 0.6), blurRadius: 16),
            ],
          ),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
            backgroundColor: t.accent.withValues(alpha: 0.35),
          ),
        );
      case UiStyle.wave:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            color: t.accent,
            backgroundColor: t.accent.withValues(alpha: 0.2),
          ),
        );
      case UiStyle.night:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(strokeWidth: 3, color: t.accent),
        );
    }
  }
}

/// Icon in a themed frame, for empty and error states.
class ThemedBadgeIcon extends StatelessWidget {
  final IconData icon;
  const ThemedBadgeIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    final box = switch (t.style) {
      UiStyle.retro => bevel(),
      UiStyle.glass => glass(radius: BorderRadius.circular(40)),
      UiStyle.wave => BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [t.accent, t.accent.withValues(alpha: 0.3)],
        ),
      ),
      UiStyle.ruby => BoxDecoration(
        color: t.elevated,
        borderRadius: BorderRadius.circular(16),
      ),
      UiStyle.night => BoxDecoration(color: t.elevated, shape: BoxShape.circle),
    };
    final light = t.style == UiStyle.glass || t.style == UiStyle.wave;
    return Container(
      width: 72,
      height: 72,
      decoration: box,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 34,
        color: light
            ? Colors.white
            : (t.style == UiStyle.retro ? t.accent : t.subdued),
      ),
    );
  }
}

/// "Nothing here yet" block: themed icon, title and an optional line and action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final retro = Pm.current.style == UiStyle.retro;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemedBadgeIcon(icon),
            const SizedBox(height: 16),
            Text(
              retro ? title.toUpperCase() : title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: retro ? 16 : 20,
                fontWeight: FontWeight.w800,
                letterSpacing: retro ? 1.5 : null,
                color: retro ? Pm.accent : null,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Pm.subdued, fontSize: 14),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Background of a page under a header: the cover color (night), the theme's own gradient
/// (wave, glass), flat black (ruby) or a gray window (retro).
List<Color> pageGradient(Color cover) {
  final t = Pm.current;
  return switch (t.style) {
    UiStyle.night => [
      cover,
      Color.lerp(cover, Colors.black, 0.12)!.withValues(alpha: 0.6),
      t.base,
    ],
    UiStyle.ruby => [t.base, t.base, t.base],
    UiStyle.wave => [
      Color.lerp(cover, t.accent, 0.55)!,
      t.accent.withValues(alpha: 0.25),
      t.base,
    ],
    UiStyle.retro => [t.highlight, t.base, t.base],
    UiStyle.glass => [Color.lerp(cover, t.accent, 0.6)!, t.press, t.base],
  };
}

/// Search field box, text and hint colors. Night keeps the white box on the phone and the dark
/// pill on the desktop; the other themes have their own field.
({Decoration box, Color text, Color hint}) searchBox({
  required bool focused,
  required bool phone,
}) {
  final t = Pm.current;
  return switch (t.style) {
    UiStyle.night =>
      phone
          ? (
              box: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              text: Colors.black,
              hint: Colors.black54,
            )
          : (
              box: BoxDecoration(
                color: t.elevated,
                borderRadius: BorderRadius.circular(500),
                border: Border.all(
                  color: focused ? t.text : Colors.transparent,
                  width: 2,
                ),
              ),
              text: t.text,
              hint: t.subdued,
            ),
    UiStyle.ruby => (
      box: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(500),
        border: Border.all(
          color: focused ? t.accent : const Color(0xFF303030),
          width: focused ? 1.5 : 1,
        ),
      ),
      text: t.text,
      hint: t.subdued,
    ),
    UiStyle.wave => (
      box: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: focused ? t.accent : t.accent.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      text: t.text,
      hint: t.subdued,
    ),
    UiStyle.retro => (
      box: bevel(pressed: true, color: Colors.black),
      text: t.accent,
      hint: t.accent.withValues(alpha: 0.45),
    ),
    UiStyle.glass => (
      box: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [t.black, t.elevated],
        ),
        border: Border.all(
          color: focused ? Colors.white70 : t.accent.withValues(alpha: 0.6),
        ),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: t.accent.withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ]
            : const [],
      ),
      text: Colors.white,
      hint: t.subdued,
    ),
  };
}

/// Small list heading (queue groups, panel titles) in the theme's voice.
class SmallHeading extends StatelessWidget {
  final String text;
  final double size;
  const SmallHeading(this.text, {super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    return switch (t.style) {
      UiStyle.retro => Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: t.accent,
          fontSize: size - 3,
          letterSpacing: 1.5,
        ),
      ),
      UiStyle.glass => Align(
        alignment: Alignment.centerLeft,
        child: TypeLabel(text),
      ),
      UiStyle.wave => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: size + 2,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),
      _ => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
      ),
    };
  }
}
