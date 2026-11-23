# Updates and releases

The app updates itself on Android and Windows when an extras server is configured.

## How the app updates

1. 20 s after launch, every hour, and when the app returns to the foreground (at most every 10 min)
   it calls `GET /api/player/update` on the extras server with the Jellyfin token
   (`Authorization: MediaBrowser Token="..."`). The server validates the token against Jellyfin
   (`/Users/Me`) and answers `{"build": N, "notes": "...", "apk": {"sha256", "size"}, "windows": {...}}`.
2. If `N` is newer than `appBuild` (`lib/version.dart`) and not the build already downloaded
   (`updateWanted` in `lib/state/updater.dart`), it downloads `GET /api/player/update/apk` or
   `/windows` in the background and checks the sha256.
3. When ready, a dialog and a strip at the top offer the update.
   - Android opens the package installer (`REQUEST_INSTALL_PACKAGES`; the first time the user allows
     "install unknown apps" for Pudim).
   - Windows runs the Inno Setup installer with `/VERYSILENT /SUPPRESSMSGBOXES /NORESTART
     /CLOSEAPPLICATIONS` and reopens the app.

## Publishing a build

A release must:

- bump `appBuild` in `lib/version.dart` and the `+N` of `version:` in `pubspec.yaml` together;
- build with the **same application id** and the **same signing key** (`android/key.properties`) as
  the installed app, or Android refuses to install over it;
- keep CompanyName/ProductName in `windows/runner/Runner.rc` (or set `PUDIM_LEGACY_DATA_DIR`);
- upload the APK and installer, and only then the version file with their sha256 and size, so an app
  never sees a version whose files are not there yet;
- be built from `main`, with the release commit pushed to `main`.

The extras server is [pudim-server](https://github.com/thiago-slb/pudim-server).
