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
