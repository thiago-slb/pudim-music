# Changelog

Build numbers are the `appBuild` in `lib/version.dart` (the Android `versionCode`). Builds are
published to the extras server and installed by the in-app updater; see [docs/updates.md](docs/updates.md).

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
