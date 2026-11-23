import 'package:material_ui/material_ui.dart';

/// Spotify-style colors (dark theme).
class Pm {
  static const black = Color(0xFF000000);
  static const base = Color(0xFF121212);
  static const elevated = Color(0xFF1F1F1F);
  static const highlight = Color(0xFF2A2A2A);
  static const press = Color(0xFF333333);
  static const text = Color(0xFFFFFFFF);
  static const subdued = Color(0xFFB3B3B3);
  static const muted = Color(0xFF7C7C7C);
  static const green = Color(0xFF1ED760);
  static const greenDark = Color(0xFF1DB954);
  static const radius = 8.0;
}

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: Pm.green,
    onPrimary: Colors.black,
    secondary: Pm.green,
    surface: Pm.base,
    onSurface: Pm.text,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Pm.black,
    fontFamily: 'Segoe UI',
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.white10,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: Pm.text, displayColor: Pm.text),
    iconTheme: const IconThemeData(color: Pm.subdued),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Pm.highlight,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Pm.text, fontSize: 13),
      waitDuration: const Duration(milliseconds: 500),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 4,
      activeTrackColor: Pm.text,
      inactiveTrackColor: Color(0xFF4D4D4D),
      thumbColor: Pm.text,
      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Pm.highlight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: const TextStyle(color: Pm.text, fontSize: 14),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white24),
      thickness: WidgetStateProperty.all(10),
      radius: Radius.zero,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: Pm.subdued),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF3D91F4),
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// "3 h 50 min" / "42 min 10 s", as in the Spotify header.
String formatTotal(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  if (h > 0) return '$h h $m min';
  return '$m min ${d.inSeconds.remainder(60)} s';
}
