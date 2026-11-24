import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Remembers how far each page was scrolled and puts it back when the user returns with Back.
/// The app navigates with `go`, which rebuilds the page from scratch, so the position is kept
/// here per location. Only the page's main vertical list counts (carousels and pill rows
/// inside it are left alone).
class ScrollMemory extends StatefulWidget {
  final String location;
  final Widget child;
  const ScrollMemory({super.key, required this.location, required this.child});

  static final _offsets = <String, double>{};
  static String? _restoreFor;

  /// Called right before going back to [location]: its page opens where it was left.
  static void markBack(String location) => _restoreFor = location;

  @visibleForTesting
  static void reset() {
    _offsets.clear();
    _restoreFor = null;
  }

  @override
  State<ScrollMemory> createState() => _ScrollMemoryState();
}

class _ScrollMemoryState extends State<ScrollMemory> {
  double? _pending;
  Timer? _giveUp;

  @override
  void initState() {
    super.initState();
    if (ScrollMemory._restoreFor == widget.location) {
      ScrollMemory._restoreFor = null;
      _pending = ScrollMemory._offsets[widget.location];
      // Content that never gets long enough again (fewer items now) stops waiting.
      _giveUp = Timer(const Duration(seconds: 4), () => _pending = null);
    }
  }

  @override
  void dispose() {
    _giveUp?.cancel();
    super.dispose();
  }

  bool _onNotification(Notification n) {
    if (n is! ScrollMetricsNotification && n is! ScrollUpdateNotification) {
      return false;
    }
    final (depth, metrics, ctx) = switch (n) {
      ScrollMetricsNotification m => (m.depth, m.metrics, m.context),
      ScrollUpdateNotification u => (u.depth, u.metrics, u.context),
      _ => throw StateError('unreachable'),
    };
    if (depth != 0 || metrics.axis != Axis.vertical) return false;
    if (n is ScrollUpdateNotification) {
      // The user scrolled first: their position wins over the remembered one.
      if (n.dragDetails != null) _pending = null;
      ScrollMemory._offsets[widget.location] = metrics.pixels;
      if (ScrollMemory._offsets.length > 200) {
        ScrollMemory._offsets.remove(ScrollMemory._offsets.keys.first);
      }
      return false;
    }
    final target = _pending;
    // Waits until the list has loaded enough to reach the old spot (data may arrive later).
    if (target != null && metrics.maxScrollExtent >= target) {
      _pending = null;
      _giveUp?.cancel();
      final pos = ctx == null ? null : Scrollable.maybeOf(ctx)?.position;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && pos != null && pos.hasPixels) pos.jumpTo(target);
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<Notification>(
    onNotification: _onNotification,
    child: widget.child,
  );
}
