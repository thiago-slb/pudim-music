import 'package:material_ui/material_ui.dart';

import 'widgets/themed.dart';

/// Which layout family a theme uses: mini player, navigation, Now Playing, lists and buttons.
enum UiStyle {
  /// Dark, rounded cards, floating mini player, bottom bar.
  night,

  /// Pure black, big square covers, flat full-width mini player with a top progress line.
  ruby,

  /// Gradients, bold type, pill mini player, highlighted bottom tabs.
  wave,

  /// Bevelled gray window, green LCD with scrolling title, small transport keys, text playlist.
  retro,

  /// Glossy glass, orb play button, visualizer, table-like lists.
  glass,
}

/// One look for the whole app: colors, corners, type and layout family. Inspired by the general
/// style of other players only: no logos, icons, artwork or fonts of theirs, no brand names.
class AppTheme {
  const AppTheme({
    required this.id,
    required this.name,
    required this.black,
    required this.base,
    required this.elevated,
    required this.highlight,
    required this.press,
    required this.text,
    required this.subdued,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.sliderInactive,
    required this.style,
    this.coverRadius = 6,
    this.hero,
    this.radius = 8,
    this.fontFamily = 'Segoe UI',
    this.fontFamilyFallback,
    this.bar,
    this.lcd = false,
    this.eqBars = false,
  });

  /// Saved in the preferences; never change an existing one.
  final String id;

  /// Proper name shown in Settings (the same in every language).
  final String name;
  final Color black, base, elevated, highlight, press;
  final Color text, subdued, muted;
  final Color accent, onAccent, sliderInactive;

  final UiStyle style;

  /// Corners of covers in cards and Now Playing.
  final double coverRadius;

  /// Background gradient for headers and Now Playing (null = from the cover color).
  final List<Color>? hero;

  /// Corners of cards and menus.
  final double radius;
  final String fontFamily;
  final List<String>? fontFamilyFallback;

  /// Player bar and mini player background (gradient, bevel); null = flat [black].
  final BoxDecoration? bar;

  /// Track title in a dark "LCD" box with [accent] text.
  final bool lcd;

  /// Small animated level bars next to the title while playing.
  final bool eqBars;
}

const appThemes = <AppTheme>[
  // Default: dark gray and green (streaming-app style).
  AppTheme(
    id: 'night',
    name: 'Noite',
    style: UiStyle.night,
    coverRadius: 6,
    black: Color(0xFF000000),
    base: Color(0xFF121212),
    elevated: Color(0xFF1F1F1F),
    highlight: Color(0xFF2A2A2A),
    press: Color(0xFF333333),
    text: Color(0xFFFFFFFF),
    subdued: Color(0xFFB3B3B3),
    muted: Color(0xFF7C7C7C),
    accent: Color(0xFF1ED760),
    onAccent: Color(0xFF000000),
    sliderInactive: Color(0xFF4D4D4D),
  ),
  // Near-black with red, rounder (video-music app style).
  AppTheme(
    id: 'red',
    name: 'Rubi',
    style: UiStyle.ruby,
    coverRadius: 2,
    black: Color(0xFF000000),
    base: Color(0xFF030303),
    elevated: Color(0xFF1D1D1D),
    highlight: Color(0xFF272727),
    press: Color(0xFF3A3A3A),
    text: Color(0xFFFFFFFF),
    subdued: Color(0xFFAAAAAA),
    muted: Color(0xFF717171),
    accent: Color(0xFFFF0033),
    onAccent: Color(0xFFFFFFFF),
    sliderInactive: Color(0xFF4A4A4A),
    radius: 12,
  ),
  // Deep violet surfaces with a bright purple accent.
  AppTheme(
    id: 'wave',
    name: 'Onda',
    style: UiStyle.wave,
    coverRadius: 18,
    hero: [Color(0xFF6A1FD1), Color(0xFF2A0F57), Color(0xFF131119)],
    black: Color(0xFF0B0A10),
    base: Color(0xFF131119),
    elevated: Color(0xFF1E1B27),
    highlight: Color(0xFF2A2636),
    press: Color(0xFF353046),
    text: Color(0xFFFFFFFF),
    subdued: Color(0xFFB9B3C9),
    muted: Color(0xFF7E7791),
    accent: Color(0xFFA238FF),
    onAccent: Color(0xFFFFFFFF),
    sliderInactive: Color(0xFF453E58),
    radius: 14,
  ),
  // 2000s desktop player: gray bevelled panels, green LCD text, level bars.
  AppTheme(
    id: 'retro',
    name: 'Retrô',
    style: UiStyle.retro,
    coverRadius: 0,
    black: Color(0xFF1B1B22),
    base: Color(0xFF26262E),
    elevated: Color(0xFF33333D),
    highlight: Color(0xFF41414D),
    press: Color(0xFF4D4D5A),
    text: Color(0xFFE6E6E6),
    subdued: Color(0xFFA9A9B5),
    muted: Color(0xFF74747F),
    accent: Color(0xFF3CFF3C),
    onAccent: Color(0xFF000000),
    sliderInactive: Color(0xFF15151A),
    radius: 0,
    // System monospace fonts only (nothing bundled).
    fontFamily: 'Consolas',
    fontFamilyFallback: ['monospace', 'Courier New'],
    bar: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4A4A56), Color(0xFF2B2B33), Color(0xFF202027)],
      ),
      border: Border(top: BorderSide(color: Color(0xFF6A6A78))),
    ),
    lcd: true,
    eqBars: true,
  ),
  // Mid-2000s media player: black and blue with a glossy glow.
  AppTheme(
    id: 'classic',
    name: 'Vidro',
    style: UiStyle.glass,
    coverRadius: 10,
    hero: [Color(0xFF123A66), Color(0xFF07182D), Color(0xFF02060D)],
    black: Color(0xFF02060D),
    base: Color(0xFF07111F),
    elevated: Color(0xFF0E1E33),
    highlight: Color(0xFF16304F),
    press: Color(0xFF1E3D63),
    text: Color(0xFFFFFFFF),
    subdued: Color(0xFFA8C2DE),
    muted: Color(0xFF6C86A3),
    accent: Color(0xFF3FA9F5),
    onAccent: Color(0xFF000000),
    sliderInactive: Color(0xFF1B3352),
    radius: 6,
    bar: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2E5A8C),
          Color(0xFF0E2A4D),
          Color(0xFF041427),
          Color(0xFF020A16),
        ],
        stops: [0, 0.45, 0.5, 1],
      ),
      border: Border(top: BorderSide(color: Color(0xFF6FB6F2))),
      boxShadow: [BoxShadow(color: Color(0x553FA9F5), blurRadius: 12)],
    ),
  ),
];

AppTheme themeById(String? id) =>
    appThemes.firstWhere((t) => t.id == id, orElse: () => appThemes.first);

/// Colors of the theme in use. Read at build time; changing the theme rebuilds every widget.
class Pm {
  static AppTheme current = appThemes.first;
  static Color get black => current.black;
  static Color get base => current.base;
  static Color get elevated => current.elevated;
  static Color get highlight => current.highlight;
  static Color get press => current.press;
  static Color get text => current.text;
  static Color get subdued => current.subdued;
  static Color get muted => current.muted;
  static Color get accent => current.accent;
  static Color get onAccent => current.onAccent;
  static double get radius => current.radius;
}

ThemeData buildTheme([AppTheme? theme]) {
  final t = theme ?? Pm.current;
  final scheme = ColorScheme.dark(
    primary: t.accent,
    onPrimary: t.onAccent,
    secondary: t.accent,
    onSecondary: t.onAccent,
    surface: t.base,
    onSurface: t.text,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: t.black,
    fontFamily: t.fontFamily,
    fontFamilyFallback: t.fontFamilyFallback,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.white10,
  );
  final small = BorderRadius.circular(t.radius == 0 ? 0 : 4);
  // Floating surfaces (menus, dialogs, sheets) and buttons in the theme's language.
  final surface = switch (t.style) {
    UiStyle.retro => t.elevated,
    UiStyle.ruby => const Color(0xFF212121),
    UiStyle.wave => Color.lerp(t.elevated, t.accent, 0.12)!,
    UiStyle.glass => t.elevated,
    UiStyle.night => t.highlight,
  };
  final OutlinedBorder buttonShape = switch (t.style) {
    UiStyle.retro => const BevelBorder(),
    UiStyle.ruby => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    UiStyle.night || UiStyle.wave || UiStyle.glass => const StadiumBorder(),
  };
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: t.text, displayColor: t.text),
    iconTheme: IconThemeData(color: t.subdued),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: t.highlight, borderRadius: small),
      textStyle: TextStyle(color: t.text, fontSize: 13),
      waitDuration: const Duration(milliseconds: 500),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 4,
      activeTrackColor: t.lcd ? t.accent : t.text,
      inactiveTrackColor: t.sliderInactive,
      thumbColor: t.lcd ? t.accent : t.text,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: surface,
      shape: surfaceShape(t),
      textStyle: TextStyle(color: t.text, fontSize: 14),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      shape: surfaceShape(t, 16),
      titleTextStyle: TextStyle(
        color: t.style == UiStyle.retro ? t.accent : t.text,
        fontFamily: t.fontFamily,
        fontSize: t.style == UiStyle.wave ? 24 : 20,
        fontWeight: t.style == UiStyle.wave ? FontWeight.w900 : FontWeight.w700,
        letterSpacing: t.style == UiStyle.retro ? 1.2 : null,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      modalBackgroundColor: surface,
      shape: sheetShape(t),
      dragHandleColor: t.muted,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: t.accent,
      linearTrackColor: t.highlight,
    ),
    dividerTheme: DividerThemeData(
      color: t.style == UiStyle.retro ? t.muted : Colors.white12,
      thickness: t.style == UiStyle.retro ? 2 : 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? t.onAccent : t.subdued,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? t.accent : t.highlight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: t.text,
        side: BorderSide(color: t.style == UiStyle.glass ? t.accent : t.muted),
        shape: buttonShape,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: t.accent,
        foregroundColor: t.onAccent,
        shape: buttonShape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: t.style == UiStyle.night ? t.text : t.accent,
        shape: buttonShape,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white24),
      thickness: WidgetStateProperty.all(10),
      radius: Radius.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: t.subdued),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: switch (t.style) {
        UiStyle.retro => t.elevated,
        UiStyle.ruby => const Color(0xFFF1F1F1),
        UiStyle.wave => t.accent,
        UiStyle.glass => t.press,
        UiStyle.night => const Color(0xFF3D91F4),
      },
      contentTextStyle: TextStyle(
        color: switch (t.style) {
          UiStyle.retro => t.accent,
          UiStyle.ruby => Colors.black,
          UiStyle.wave => t.onAccent,
          _ => Colors.white,
        },
        fontFamily: t.fontFamily,
        fontWeight: t.style == UiStyle.wave ? FontWeight.w800 : null,
      ),
      shape: surfaceShape(t, t.style == UiStyle.wave ? 24 : null),
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
