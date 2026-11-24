# Themes

Settings > Appearance picks one of the looks in `appThemes` (`lib/ui/theme.dart`). The choice is
saved on the device (`theme` in the preferences) and applied at once.

## How it works

- `AppTheme` holds the tokens: background shades (`black`, `base`, `elevated`, `highlight`,
  `press`), text shades, `accent` / `onAccent`, corner `radius`, font family, and the player bar's
  style (`bar` decoration, `lcd` title panel, `eqBars` level bars).
- Widgets read colors from `Pm.*`, which forwards to `Pm.current`. Because those are read while
  building, `AppThemeChoice.set` calls `rebuildAllWidgets()` so every widget on screen builds again
  (pages, scroll positions and the queue are kept).
- `buildTheme(theme)` builds the Material `ThemeData` from the same tokens.

## Adding a theme

1. Add an `AppTheme` to `appThemes` with a new, permanent `id` and a proper name of our own.
2. Add its description to `_ThemePicker._desc` and a `theme<Id>Desc` key to every `app_*.arb`.
3. `test/themes_test.dart` checks ids and contrast (text 7:1, secondary text 4.5:1, accent 3:1).

## Legal

Themes may be inspired by other players' palettes and styling only. Do not use their logos, icons,
artwork or fonts, and do not use their brand names as theme names (descriptions may say which style
inspired the theme). Fonts are system fonts only; nothing is bundled.
