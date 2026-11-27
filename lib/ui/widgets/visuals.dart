import 'dart:math';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';

import '../theme.dart';

/// Animated visualizations for the Now Playing screen (glass theme) and its full-screen view.
/// Original drawings, not driven by the audio: a beat-like pulse (tempo picked per track)
/// gives the motion life while playing; paused, they slow down to a calm drift.
enum VisualKind { waves, swirl, bars, nebula }

class AmbientVisual extends StatefulWidget {
  final bool playing;
  final VisualKind kind;

  /// Changes the tempo and shapes per track (any stable value, e.g. the track id).
  final String seed;
  const AmbientVisual({
    super.key,
    required this.playing,
    required this.kind,
    this.seed = '',
  });

  @override
  State<AmbientVisual> createState() => _AmbientVisualState();
}

class _AmbientVisualState extends State<AmbientVisual>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final _time = ValueNotifier<double>(0);
  Duration _last = Duration.zero;
  double _speed = 0.15;

  @override
  void initState() {
    super.initState();
    _speed = widget.playing ? 1 : 0.15;
    _ticker.start();
  }

  void _tick(Duration now) {
    final dt = ((now - _last).inMicroseconds / 1e6).clamp(0.0, 0.1);
    _last = now;
    // Eases between full motion (playing) and a slow drift (paused).
    final want = widget.playing ? 1.0 : 0.15;
    _speed += (want - _speed) * min(1, dt * 2.5);
    _time.value += dt * _speed;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(
      painter: _VisualPainter(
        time: _time,
        kind: widget.kind,
        seed: widget.seed.hashCode,
        accent: Pm.accent,
        energyScale: widget.playing ? 1 : 0.35,
      ),
      size: Size.infinite,
    ),
  );
}

class _VisualPainter extends CustomPainter {
  final ValueNotifier<double> time;
  final VisualKind kind;
  final int seed;
  final Color accent;
  final double energyScale;
  _VisualPainter({
    required this.time,
    required this.kind,
    required this.seed,
    required this.accent,
    required this.energyScale,
  }) : super(repaint: time);

  double get t => time.value;

  /// Tempo for this track: 96 to 128 beats per minute.
  double get _bps => (96 + (seed.abs() % 33)) / 60;

  /// Beat-like pulse, 0..1: a sharp rise on each beat that fades before the next.
  double pulseAt(double t) {
    final phase = (t * _bps) % 1;
    return pow(1 - phase, 3).toDouble();
  }

  /// Overall loudness feel, 0..1.
  double energyAt(double t) {
    final slow = 0.5 + 0.25 * sin(t * 0.37 + seed) + 0.15 * sin(t * 0.91);
    return ((0.35 + 0.4 * slow + 0.35 * pulseAt(t)) * energyScale).clamp(
      0.0,
      1.0,
    );
  }

  /// Level of band [i] of [n] at time [t] (lower bands move more on the beat).
  double bandAt(int i, int n, double t) {
    final f = i / n;
    final s = seed % 97;
    final wobble =
        (sin(t * (1.3 + f * 3.1) + i * 1.7 + s) *
                cos(t * (0.7 + f * 1.9) + i * 0.6) +
            1) /
        2;
    final beat = pulseAt(t) * (1 - f) * 0.6;
    final tilt = 0.85 - f * 0.35;
    return ((0.15 + 0.55 * wobble * tilt + beat) * energyScale).clamp(
      0.02,
      1.0,
    );
  }

  /// A color around the accent, [shift] turns the hue (degrees).
  Color tone(double shift, {double light = 0.6, double alpha = 1}) {
    final h = HSLColor.fromColor(accent);
    return h
        .withHue((h.hue + shift) % 360)
        .withSaturation(max(0.55, h.saturation))
        .withLightness(light.clamp(0.0, 1.0))
        .toColor()
        .withValues(alpha: alpha);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    switch (kind) {
      case VisualKind.waves:
        _waves(canvas, size);
      case VisualKind.swirl:
        _swirl(canvas, size);
      case VisualKind.bars:
        _bars(canvas, size);
      case VisualKind.nebula:
        _nebula(canvas, size);
    }
    canvas.restore();
  }

  /// Glowing ribbons across the screen, mirrored around the middle.
  void _waves(Canvas canvas, Size s) {
    final mid = s.height / 2;
    final e = energyAt(t);
    for (var k = 0; k < 5; k++) {
      final path = Path();
      final amp = s.height * (0.08 + 0.3 * e) * (1 - k * 0.14);
      final freq = 1.5 + k * 0.7;
      for (var x = 0.0; x <= s.width; x += 4) {
        final u = x / s.width;
        final env = sin(pi * u); // calm at the edges
        final y =
            mid +
            env *
                amp *
                (sin(u * freq * 2 * pi + t * (1.2 + k * 0.45) + k) * 0.7 +
                    sin(u * freq * 5.3 + t * 2.1 - k) * 0.3);
        x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      final color = tone(k * 18.0 - 30, light: 0.55 + k * 0.06);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7 - k.toDouble()
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
          ..blendMode = BlendMode.plus,
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = color.withValues(alpha: 0.9)
          ..blendMode = BlendMode.plus,
      );
      // Reflection
      canvas.save();
      canvas.translate(0, 2 * mid);
      canvas.scale(1, -1);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color.withValues(alpha: 0.18)
          ..blendMode = BlendMode.plus,
      );
      canvas.restore();
    }
  }

  /// Particles turning around the center, rings breathing with the beat (with short trails).
  void _swirl(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final maxR = s.shortestSide * 0.48;
    final rnd = Random(seed);
    const n = 180;
    final specs = [
      for (var i = 0; i < n; i++)
        (
          ring: rnd.nextDouble(),
          a0: rnd.nextDouble() * 2 * pi,
          sz: rnd.nextDouble(),
        ),
    ];
    for (var ghost = 4; ghost >= 0; ghost--) {
      final tt = t - ghost * 0.035;
      final e = energyAt(tt);
      final alpha = ghost == 0 ? 0.95 : 0.18 / ghost;
      for (final p in specs) {
        final r = maxR * (0.12 + 0.88 * p.ring) * (0.8 + 0.3 * e);
        final speed = 0.25 + (1 - p.ring) * 0.9;
        final a = p.a0 + tt * speed * (p.ring > 0.5 ? 1 : -1);
        final wob = sin(tt * 2 + p.a0 * 3) * 6 * e;
        final o = c + Offset(cos(a) * (r + wob), sin(a) * (r + wob) * 0.82);
        canvas.drawCircle(
          o,
          0.8 + p.sz * 2.4 * (0.6 + e),
          Paint()
            ..color = tone(p.ring * 120 - 40, light: 0.6, alpha: alpha)
            ..blendMode = BlendMode.plus,
        );
      }
    }
    // Soft core that pulses.
    final pe = pulseAt(t) * energyScale;
    canvas.drawCircle(
      c,
      maxR * (0.22 + 0.1 * pe),
      Paint()
        ..shader = ui.Gradient.radial(c, maxR * (0.22 + 0.1 * pe), [
          tone(0, light: 0.75, alpha: 0.55 + 0.3 * pe),
          tone(0, alpha: 0),
        ])
        ..blendMode = BlendMode.plus,
    );
  }

  /// Spectrum-style bars with falling peak caps and a floor reflection.
  void _bars(Canvas canvas, Size s) {
    final n = (s.width / 14).clamp(16, 64).round();
    final w = s.width / n;
    final floor = s.height * 0.72;
    final top = floor - s.height * 0.06;
    for (var i = 0; i < n; i++) {
      final lv = bandAt(i, n, t);
      final h = top * lv;
      final x = i * w + w * 0.15;
      final bw = w * 0.7;
      final rect = Rect.fromLTWH(x, floor - h, bw, h);
      final colors = [tone(-40, light: 0.45), tone(20, light: 0.65)];
      canvas.drawRect(
        rect,
        Paint()
          ..shader = ui.Gradient.linear(
            rect.bottomLeft,
            Offset(x, floor - top),
            colors,
          ),
      );
      // Peak: the highest level of the last moments, falling slowly.
      var peak = 0.0;
      for (var k = 0; k < 8; k++) {
        peak = max(peak, bandAt(i, n, t - k * 0.08) - k * 0.025);
      }
      final py = floor - top * peak - 4;
      canvas.drawRect(
        Rect.fromLTWH(x, py, bw, 3),
        Paint()..color = tone(30, light: 0.8),
      );
      // Reflection on the floor.
      final rh = min(h * 0.45, s.height - floor);
      canvas.drawRect(
        Rect.fromLTWH(x, floor + 2, bw, rh),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(x, floor),
            Offset(x, floor + rh),
            [tone(0, alpha: 0.35), tone(0, alpha: 0)],
          ),
      );
    }
  }

  /// Colored clouds drifting and blending, with a slowly turning star in the middle.
  void _nebula(Canvas canvas, Size s) {
    final e = energyAt(t);
    for (var k = 0; k < 6; k++) {
      final o = Offset(
        s.width * (0.5 + 0.38 * sin(t * (0.21 + k * 0.05) + k * 1.3)),
        s.height * (0.5 + 0.36 * cos(t * (0.17 + k * 0.04) + k * 2.1)),
      );
      final r =
          s.shortestSide * (0.35 + 0.15 * sin(t * 0.5 + k)) * (0.8 + 0.4 * e);
      canvas.drawCircle(
        o,
        r,
        Paint()
          ..shader = ui.Gradient.radial(o, r, [
            tone(k * 35.0 - 60, light: 0.55, alpha: 0.45),
            tone(k * 35.0 - 60, alpha: 0),
          ])
          ..blendMode = BlendMode.plus,
      );
    }
    final c = s.center(Offset.zero);
    final pe = pulseAt(t) * energyScale;
    final arms = 6 + seed.abs() % 4;
    final star = Path();
    for (var i = 0; i <= arms * 2; i++) {
      final a = i * pi / arms + t * 0.3;
      final r = s.shortestSide * (i.isEven ? 0.16 + 0.1 * pe : 0.05);
      final p = c + Offset(cos(a) * r, sin(a) * r);
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(
      star,
      Paint()
        ..color = tone(20, light: 0.8, alpha: 0.35 + 0.4 * pe)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..blendMode = BlendMode.plus,
    );
  }

  @override
  bool shouldRepaint(_VisualPainter old) =>
      old.kind != kind ||
      old.seed != seed ||
      old.accent != accent ||
      old.energyScale != energyScale;
}
