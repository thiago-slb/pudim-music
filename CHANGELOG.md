# Changelog

Build numbers are the `appBuild` in `lib/version.dart` (the Android `versionCode`). Builds are
published to the extras server and installed by the in-app updater; see [docs/updates.md](docs/updates.md).

## Build 23
- Went through every section in every theme (`test/sections_looks_test.dart` opens all 17 phone
  sections with a fake server, checks for layout errors and can save a screenshot of each).
  Fixed what it found:
  - The library filter pills were centered; sideways pill rows now start at the left.
  - History: the back arrow sat on top of the title.
  - Search, Profile, Chats and Concerts titles (and the Profile section heading) now use the
    theme's page title instead of plain bold text.
  - Lyrics with nothing playing shows the themed empty state.
  - Wave: the selected bottom tab was 6 px taller than the bar (clipped with large fonts); the
    tabs now shrink to fit.

## Build 22
- Your Library follows the theme like the other pages: the theme's gradient behind the header,
  the title in the theme's page-title style (LCD text in Retrô, glow in Glass), the filter pills in
  the shared `PillBar` (one sideways line that grows with large fonts instead of a fixed 48 px row)
  and the sort button framed per theme. `test/library_looks_test.dart` renders the header in every
  theme and checks the pills share a line.

## Build 21
- Retrô theme: the phone tabs are back at the bottom as a row of raised bevel keys (the open one
  pressed in). The thin strip at the top read as a title bar, so the navigation looked gone. A
  test checks that every theme shows every tab and that the tabs react to taps.
- Recap shows only the current year, without year pills. Settings > History has the recaps of
  every year and of each month (pills that wrap on narrow screens) and the full list of plays,
  imported history included, loading 100 at a time. Needs the server's `/api/player/history`
  and `month` on `/api/player/recap`.
- Pills: every group (Shows upcoming/past, History years and months, recent searches, artist and
  search filters, library filters, Home tabs) goes through one `PillBar`, and each pill is only as
  wide as its label. A pill inside a wrapping group took the whole line, so they stacked one under
  the other. Pills also grow with large system fonts. `test/pills_test.dart` checks one line at
  360 dp in every theme, at normal and large font.

## Build 20
- Themes reach the inner pages: album, playlist and artist headers, search field and results
  chips, library list, queue, lyrics, recap, settings, dialogs, menus, bottom sheets, toasts,
  loading and empty states each follow the theme's own style (see [docs/themes.md](docs/themes.md)).
  Pages no longer hard-code dialog, sheet or button shapes.

## Build 19
- Resume on another device: every app sends its queue, position, context, shuffle and repeat to the
  extras server on each track change, on pause and every ~15 s while playing. Opening the app (or
  coming back to it) with nothing playing picks up what another device played last, paused at the
  same point; play continues from there, including from Android Auto. A queue playing here, a Jam
  or a Chromecast is never replaced. Needs the server's `/api/player/state`.

## Build 18
- Themes change the layout, not only the colors: each one has its own mini player, navigation,
  Now Playing, list density, play button and progress bar (see [docs/themes.md](docs/themes.md)).
  Renamed Noite, Rubi, Onda, Retrô and Vidro, with a miniature preview and descriptions that name
  no other product.

## Build 17
- Updates: Settings > About has "Check for updates", which runs the check and shows the result
  (up to date, downloading with progress, or the error). The strip above the mini player shows the
  download while it runs. Failures are logged (`updater:` in logcat / the console) instead of being
  swallowed; a check before sign-in retries in 30 s, and coming back to the app checks again after
  2 min. The app sends its build and platform so the server can log each check.

## Build 16
- Themes: Settings > Appearance offers five looks, switched instantly: Verde Noite (default),
  Vermelho, Roxo Onda, Retrô Amp (gray panels, green LCD title, level bars) and Clássico Azul
  (glossy black and blue). Only palettes and styling inspired by other players; no logos, icons or
  bundled fonts. See [docs/themes.md](docs/themes.md).

## Build 15
- Android: adaptive launcher icon (dark full background, cat inside the safe zone, monochrome layer),
  so Android Auto and launchers no longer show the square art on a white plate.

## Build 14
- Fix a track playing twice at the end (seen in Android Auto): when the player moved on to the
  preloaded track without the queue following, "next" replayed it. The queue now catches up from the
  player's current index stream and again when a track ends.

## Build 13
- Updates: a dialog offers the update as soon as it is downloaded; the app also checks when it comes
  back to the foreground (at most every 10 min) and every hour. A downloaded but never installed build
  no longer blocks newer ones.

## Build 12
- Android Auto: the car display, notification and lock screen follow the track that is actually
  playing after a gapless advance; an advance that arrived while the next track was being prepared is
  retried instead of dropped.
- Android Auto: monochrome app icon (`ic_stat_pudim`) declared as
  `com.google.android.gms.car.notification.SmallIcon`; the media service carries the app icon and label.

## Build 11
- Fix gray screens in every language but English (wrong Material localizations delegate).
- Windows: `PUDIM_LEGACY_DATA_DIR` copies login, settings, queue and downloads from an older data folder.

## Build 10
- Fix gray screen on Android at startup (media session attached while the player was still building).

## Build 9
- Chromecast, several accounts and servers, CarPlay, 12 more interface languages.

## Build 8
- First build from this repository; English and Spanish.

See [docs/lessons.md](docs/lessons.md) for the causes of the bigger bugs and the guards against them.
