import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../theme.dart';

/// Background of the player bar and mini player for the theme in use.
BoxDecoration playerBarDecoration({BorderRadius? radius}) {
  final bar = Pm.current.bar;
  if (bar == null) return BoxDecoration(color: Pm.black, borderRadius: radius);
  return bar.copyWith(borderRadius: radius);
}

/// Dark "LCD" panel around the track title (Retrô Amp theme); passes [child] through otherwise.
class LcdPanel extends StatelessWidget {
  final Widget child;
  const LcdPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!Pm.current.lcd) return child;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border(
          top: const BorderSide(color: Color(0xFF111116), width: 2),
          left: const BorderSide(color: Color(0xFF111116), width: 2),
          bottom: BorderSide(color: Pm.highlight, width: 2),
          right: BorderSide(color: Pm.highlight, width: 2),
        ),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: Pm.accent, letterSpacing: 0.5),
        child: child,
      ),
    );
  }
}

/// Text color for the title inside [LcdPanel] (keeps the theme's text color elsewhere).
Color? lcdTextColor() => Pm.current.lcd ? Pm.accent : null;

/// Little animated level bars shown while playing (Retrô Amp theme).
class LevelBars extends StatefulWidget {
  final bool playing;
  final double height;
  const LevelBars({super.key, required this.playing, this.height = 18});

  @override
  State<LevelBars> createState() => _LevelBarsState();
}

class _LevelBarsState extends State<LevelBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) _c.repeat();
  }

  @override
  void didUpdateWidget(LevelBars old) {
    super.didUpdateWidget(old);
    if (widget.playing && !_c.isAnimating) _c.repeat();
    if (!widget.playing && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Pm.current.eqBars) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 5; i++)
            Container(
              width: 3,
              margin: const EdgeInsets.only(right: 2),
              height:
                  widget.height *
                  (widget.playing
                      ? 0.25 +
                            0.75 *
                                (0.5 +
                                        0.5 *
                                            sin(
                                              _c.value * 2 * pi * (1 + i % 3) +
                                                  i * 1.7,
                                            ))
                                    .abs()
                      : 0.15),
              color: Pm.accent,
            ),
        ],
      ),
    );
  }
}

/// Raised 3D edge (light top-left, dark bottom-right); [pressed] sinks it.
BoxDecoration bevel({Color? color, bool pressed = false}) {
  const light = Color(0xFF8A8A98), dark = Color(0xFF0E0E12);
  final hi = pressed ? dark : light, lo = pressed ? light : dark;
  return BoxDecoration(
    color: color ?? Pm.elevated,
    border: Border(
      top: BorderSide(color: hi, width: 2),
      left: BorderSide(color: hi, width: 2),
      bottom: BorderSide(color: lo, width: 2),
      right: BorderSide(color: lo, width: 2),
    ),
  );
}

/// Glossy glass fill: bright top half, deep bottom half, thin light rim.
BoxDecoration glass({required BorderRadius radius, Color? tint}) {
  final c = tint ?? Pm.accent;
  return BoxDecoration(
    borderRadius: radius,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(c, Colors.white, 0.45)!,
        Color.lerp(c, Colors.black, 0.15)!,
        Color.lerp(c, Colors.black, 0.55)!,
        Color.lerp(c, Colors.black, 0.35)!,
      ],
      stops: const [0, 0.48, 0.52, 1],
    ),
    border: Border.all(color: Colors.white38),
    boxShadow: [BoxShadow(color: c.withValues(alpha: 0.45), blurRadius: 14)],
  );
}

/// Glass pill (filters, sort button): a glossy capsule like the play orb. Selected glows in the
/// accent; the rest are the same gloss in a deep tint of it.
BoxDecoration glassPill({required bool selected, double radius = 32}) {
  final r = BorderRadius.circular(radius);
  if (selected) return glass(radius: r);
  final d = glass(radius: r, tint: Color.lerp(Pm.accent, Colors.black, 0.5));
  return d.copyWith(
    border: Border.all(color: Pm.accent.withValues(alpha: 0.45)),
    boxShadow: const [],
  );
}

/// The theme's main play/pause button: round (night, ruby, wave), bevelled key (retro) or
/// glossy orb (glass).
class ThemedPlayButton extends StatelessWidget {
  final double size;
  final bool playing;
  final bool busy;
  final VoidCallback? onPressed;

  /// Light button on dark backgrounds (Now Playing) instead of the accent color.
  final bool light;
  const ThemedPlayButton({
    super.key,
    this.size = 56,
    this.playing = false,
    this.busy = false,
    this.light = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final icon = playing ? Icons.pause_rounded : Icons.play_arrow_rounded;
    switch (Pm.current.style) {
      case UiStyle.retro:
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size * 0.75,
            decoration: bevel(),
            alignment: Alignment.center,
            child: Icon(icon, color: Pm.accent, size: size * 0.5),
          ),
        );
      case UiStyle.glass:
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: glass(radius: BorderRadius.circular(size)),
            alignment: Alignment.center,
            child: busy
                ? SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    icon,
                    color: Colors.white,
                    size: size * 0.55,
                    shadows: const [Shadow(blurRadius: 8)],
                  ),
          ),
        );
      default:
        final bg = light ? Pm.text : Pm.accent;
        final fg = light ? Pm.black : Pm.onAccent;
        return Material(
          color: bg,
          shape: const CircleBorder(),
          elevation: light ? 0 : 4,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: busy
                  ? Padding(
                      padding: EdgeInsets.all(size * 0.32),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: fg,
                      ),
                    )
                  : Icon(icon, color: fg, size: size * 0.6),
            ),
          ),
        );
    }
  }
}

/// Small square transport key (retro): bevelled, sinks while pressed.
class RetroKey extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool on;
  final double width;
  const RetroKey(
    this.icon, {
    super.key,
    this.onPressed,
    this.on = false,
    this.width = 40,
  });

  @override
  State<RetroKey> createState() => _RetroKeyState();
}

class _RetroKeyState extends State<RetroKey> {
  bool _down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _down = true),
    onTapCancel: () => setState(() => _down = false),
    onTapUp: (_) {
      setState(() => _down = false);
      widget.onPressed?.call();
    },
    child: Container(
      width: widget.width,
      height: 28,
      decoration: bevel(pressed: _down),
      alignment: Alignment.center,
      child: Icon(
        widget.icon,
        size: 18,
        color: widget.on ? Pm.accent : Pm.text,
      ),
    ),
  );
}

/// Text that scrolls sideways when it does not fit (the LCD title).
class Marquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  const Marquee(this.text, {super.key, required this.style});

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, box) {
      final style = DefaultTextStyle.of(context).style.merge(widget.style);
      final tp = TextPainter(
        text: TextSpan(text: widget.text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      final h = tp.height;
      if (tp.width <= box.maxWidth) {
        return SizedBox(
          height: h,
          child: Text(widget.text, style: style, maxLines: 1),
        );
      }
      final loop = tp.width + 48;
      return SizedBox(
        height: h,
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, _) => Stack(
              clipBehavior: Clip.none,
              children: [
                for (final dx in [0.0, loop])
                  Positioned(
                    left: dx - _c.value * loop,
                    top: 0,
                    child: Text(
                      widget.text,
                      style: style,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
