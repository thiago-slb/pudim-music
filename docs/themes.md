# Themes

Settings > Appearance picks one of the looks in `appThemes` (`lib/ui/theme.dart`). The choice is
saved on the device (`theme` in the preferences) and applied at once, without restarting.

Each theme changes the layout as well as the colors:

| Theme | Style (`UiStyle`) | Mini player | Navigation | Now Playing | Lists |
|---|---|---|---|---|---|
| Noite | `night` | floating card in the cover color | bottom bar | big cover over the cover color | cover rows |
| Rubi | `ruby` | flat strip docked to the bar, progress line on top, square cover | bottom bar on pure black | pure black, big square cover, thin accent progress | bigger square covers |
| Onda | `wave` | gradient pill with a round cover | bottom bar, pill behind the selected tab | purple gradient, large bold title | cover rows, bold headers |
| Retrô | `retro` | bevelled panel, LCD with scrolling title, level bars, transport keys | square tabs at the top | compact window: LCD with big time, keys, text playlist | monospace text lines |
| Vidro | `glass` | glass capsule with an orb button | glossy bottom bar, glowing selected icon | blue gradient, glowing cover, visualizer | table rows with columns and stripes |

## How it works

- `AppTheme` holds the tokens: background shades, text shades, `accent` / `onAccent`, corner
  `radius` and `coverRadius`, font family, `hero` gradient, the player bar's `bar` decoration,
  `lcd` and `eqBars`, and `style`, which picks the layout family.
- Widgets read colors from `Pm.*` (forwarding to `Pm.current`) and branch on
  `Pm.current.style`. `AppThemeChoice.set` calls `rebuildAllWidgets()` so every widget on screen
  builds again (pages, scroll positions and the queue are kept).
- Shared pieces live in `lib/ui/widgets/theme_bits.dart`: `ThemedPlayButton`, `RetroKey`,
  `bevel()`, `glass()`, `LcdPanel`, `LevelBars`, `Marquee`, `Visualizer`. The retro Now Playing is
  `lib/ui/mobile/retro_playing.dart`.
- The settings picker shows `ThemePreview`, a miniature of each layout.

## Adding a theme

1. Add an `AppTheme` to `appThemes` with a new, permanent `id`, a proper name of our own and a
   `style` (or a new `UiStyle` value, then handle it in every `switch`).
2. Add its description to `_ThemePicker._desc` and a `theme<Id>Desc` key to every `app_*.arb`.
3. `test/themes_test.dart` checks ids, contrast and that no name or description mentions a brand;
   `test/theme_looks_test.dart` renders each style's pieces.

## Legal

Themes may take inspiration from the general style of other players only. No logos, icons,
artwork, fonts or pixel copies of their screens, and no brand names anywhere in the picker
(names or descriptions). Fonts are system fonts only; nothing is bundled.
