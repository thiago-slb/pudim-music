# Pudim

A music player for [Jellyfin](https://jellyfin.org), built with Flutter for Android, Windows, macOS, Linux, iOS and the web.
It aims for the feel of a modern streaming app: a home page with shelves, fast search, a full-screen "now playing",
synced lyrics, offline downloads, and an optional extras server for social features.

The interface is available in **Portuguese (Brazil)**, **English** and **Spanish**. It follows the device language
(falling back to Portuguese) and can be changed in Settings. See [Translations](#translations) to add another language.

## Features

**Works with any Jellyfin server**

- Home with quick picks, recently played, most played albums and artists, recently added and your playlists
- Library with sorting and filtering; album, artist and playlist pages; liked songs
- Search across songs, albums, artists and playlists
- Queue with drag to reorder, shuffle, repeat, autoplay (Jellyfin instant mix) and "Smart Shuffle" recommendations
- Artist radio and instant mixes
- Synced lyrics (from Jellyfin), full screen or in the side panel
- Offline downloads of albums and playlists, with automatic offline mode when the connection drops
- Create, edit and add to playlists; favorites
- Playback reporting to Jellyfin (play counts, resume, "recently played")
- OS media controls: Android notification and lock screen, Windows media keys and overlay (SMTC)
- Android home-screen widget
- Separate local and remote server addresses (uses the local one when it answers)
- Desktop layout with three columns and keyboard shortcuts; phone layout with bottom navigation and mini player

**With the optional extras server** (hidden in the app when not configured)

- Chat between accounts on the same server, sharing songs, albums and playlists
- Jam: listen together on one shared queue
- Blend: a shared playlist with a taste match score
- Collaborative playlists ("added by" on each song)
- Auto mixes: weekly discovery, release radar, daylist
- Yearly recap with shareable cards
- Concerts, podcasts and Last.fm scrobbling
- Requesting downloads into the library and automatic app updates

The extras server is a separate service that speaks the `/api/player/*` HTTP API and authenticates with the same
Jellyfin token. The open-source implementation is **[pudim-server](https://github.com/thiago-slb/pudim-server)**
(GPL-3.0, Python, Docker image included); it covers everything above except downloads into the library and weekly
discovery, which depend on a separate download pipeline. The app is a complete Jellyfin player without it.

## Comparison with other Jellyfin music clients

✅ yes · ❌ no · ◐ partial (see notes) · ? not documented by the project (not necessarily missing)

| | **Pudim** | Finamp | Feishin | Symfonium | Manet | Jellify | Supersonic | Jellyfin Web |
|---|---|---|---|---|---|---|---|---|
| License | GPL-3.0 | MPL-2.0 | GPL-3.0 | Proprietary | Proprietary | MIT | GPL-3.0 | GPL-2.0 |
| Price | Free | Free | Free | Paid | Free + IAP | Free | Free | Free |
| Android | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | ◐¹ |
| iOS | ◐² | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ | ◐¹ |
| Windows | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ◐¹ |
| macOS | ◐² | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ◐¹ |
| Linux | ◐² | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ◐¹ |
| Web | ◐² | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Offline downloads | ✅ | ✅ | ? | ✅ | ✅ | ✅ | ◐³ | ❌ |
| Gapless playback | ✅ | ✅ | ✅⁴ | ✅ | ? | ✅ | ✅ | ◐⁵ |
| ReplayGain / normalization | ✅ | ✅ | ✅ | ✅ | ✅ | ✅⁶ | ✅ | ✅ |
| Streaming quality / transcoding | ✅ | ✅ | ✅ | ✅ | ◐ | ✅ | ? | ? |
| Synced lyrics | ✅ | ✅ | ✅ | ✅ | ✅ | ? | ◐⁷ | ◐⁷ |
| Sleep timer | ✅ | ✅ | ✅ | ✅ | ? | ? | ? | ? |
| Playback speed | ✅ | ✅ | ✅ | ✅ | ? | ? | ? | ? |
| Android Auto | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | ? |
| CarPlay | ◐¹⁸ | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ | ? |
| Chromecast / casting | ❌ | ◐⁸ | ◐⁹ | ✅ | ? | ◐¹⁰ | ◐⁹ | ✅ |
| Quick Connect login | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ? | ✅ |
| Instant mix / radio | ✅ | ✅ | ✅ | ✅ | ? | ✅ | ◐¹¹ | ✅ |
| Multiple servers | ❌ | ? | ✅ | ✅ | ? | ? | ✅ | ❌ |
| Android home-screen widget | ✅ | ? | ❌ | ✅ | ❌ | ? | ❌ | ❌ |
| Last.fm scrobbling | ◐¹² | ? | ◐¹³ | ? | ◐¹³ | ◐¹³ | ? | ? |
| Auto mixes / smart playlists | ◐¹² | ◐¹⁴ | ◐¹⁵ | ✅ | ? | ❌ | ? | ? |
| Listen together / social | ◐¹² | ? | ? | ? | ? | ❌¹⁶ | ? | ✅¹⁷ |
| OS media controls / media keys | ✅ | ? | ✅ | ❌ | ? | ❌ | ✅ | ? |
| Interface languages | pt, en, es | many | many | many | ? | ? | ? | many |

1. Runs in any browser; the official desktop and mobile apps wrap it.
2. Builds from the same code, but only Android and Windows are tested regularly.
3. Downloads songs, albums and playlists; a full offline mode is planned.
4. With the mpv backend (desktop builds).
5. Through a third-party server plugin.
6. Loudness normalization (ReplayGain is not named).
7. Lyrics are supported; synced lyrics are not documented.
8. "Play On" remote control from other Jellyfin clients.
9. DLNA/UPnP only.
10. Google Cast described as early stage.
11. Artist radio plus internet radio stations.
12. Needs the optional Pudim extras server (Last.fm; weekly discovery, release radar, daylist, Blend; chat, Jam, collaborative playlists).
13. Through the Jellyfin server's Last.fm plugin, not the client.
14. Through the AudioMuse integration.
15. The smart playlist editor is Navidrome-only.
16. On the roadmap.
17. SyncPlay, built into the Jellyfin server.
18. Same folders as Android Auto. Compiles in CI but has not been tried in a car yet; a real car needs Apple's CarPlay audio entitlement (see Building).

As of November 2026. Other clients' features come from each project's README, website, store page or release notes:
[Finamp](https://github.com/finamp-app/finamp) ·
[Feishin](https://github.com/jeffvli/feishin) ·
[Symfonium](https://symfonium.app/) ·
[Manet](https://apps.apple.com/us/app/manet-music/id6470928235) ·
[Jellify](https://github.com/Jellify-Music/App) ·
[Supersonic](https://github.com/dweymouth/supersonic) ·
[Jellyfin Web](https://github.com/jellyfin/jellyfin-web).
Corrections are welcome: open an issue with a link.

## Getting started

Download a build from the [releases](../../releases) (or the latest CI artifact), open the app and type:

- **Jellyfin server**: your server address, e.g. `https://jellyfin.example.com`
- **On the local network** (optional): a LAN address, e.g. `http://192.168.0.10:8096`, used whenever it answers
- **Extras server** (optional): the address of a [pudim-server](https://github.com/thiago-slb/pudim-server), if you run one

Then sign in with your Jellyfin user name and password. The password goes only to your server; the app keeps
just the access token (Windows Credential Manager / Android Keystore).

## Building

Requirements: [Flutter](https://flutter.dev) 3.50 or newer.

```sh
flutter pub get
flutter run            # current platform
flutter test
```

- **Android**: `flutter build apk --release`. To sign with your own key, create `android/key.properties`
  (ignored by git) with `storeFile`, `storePassword`, `keyAlias` and `keyPassword`; without it the debug key is used.
  To use your own application id, set `PUDIM_APP_ID` (or `-Ppudim.appId=...`); the default is `io.github.thiagoslb.pudim`.
- **Windows**: `flutter build windows --release`. The media controls plugin needs [rustup](https://rustup.rs).
  `windows/installer.iss` builds an installer with [Inno Setup 6](https://jrsoftware.org/isinfo.php).
- **macOS / iOS / Linux / web**: the standard `flutter build <platform>`. These targets compile but get less testing.
- **CarPlay** (`ios/Runner/CarPlaySceneDelegate.swift`): simulator builds already include the CarPlay entitlement,
  so it shows up in Xcode's CarPlay simulator (I/O → External Displays → CarPlay). For a real car, ask Apple for the
  [CarPlay audio entitlement](https://developer.apple.com/carplay/), add it to your provisioning profile and set
  `CODE_SIGN_ENTITLEMENTS = Runner/CarPlay.entitlements` for device builds. Open the app on the iPhone once before
  connecting: the car lists come from the Flutter side.

### Default addresses for your own builds

The source code ships with no server addresses. To prefill the login screen in your own builds, copy
`pudim.example.json` to `pudim.local.json` (ignored by git), fill it in and build with:

```sh
flutter build apk --release --dart-define-from-file=pudim.local.json
```

| Key | Meaning |
|---|---|
| `PUDIM_SERVER_URL` | Main Jellyfin address |
| `PUDIM_SERVER_LAN_URL` | Optional LAN address, tried first |
| `PUDIM_EXTRAS_URL` | Optional extras server |

Everything can also be changed in the app (login screen and Settings).

## Translations

Texts live in [`lib/l10n/`](lib/l10n) as ARB files and are compiled with Flutter's
[gen-l10n](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization):
`app_pt.arb` is the template (and the fallback), `app_en.arb` and `app_es.arb` are the translations.

To add a language:

1. Copy `lib/l10n/app_en.arb` to `lib/l10n/app_<code>.arb` (e.g. `app_fr.arb`), set `"@@locale"` to the code and
   translate the values. Keep the `{placeholders}` and the ICU `plural`/`select` structure; the `@key` entries in
   `app_pt.arb` describe the placeholders.
2. Add the code to `appLanguages` in [`lib/l10n/l10n.dart`](lib/l10n/l10n.dart) and to the language picker in
   [`lib/features/settings/settings_page.dart`](lib/features/settings/settings_page.dart).
3. Run `flutter gen-l10n` (or just `flutter run`), then `flutter analyze` and `flutter test`.

Names of the auto-generated playlists (e.g. "Descobertas", "Mistura da semana", "Radar de Novidades") are matched by
the extras server and stay as they are in every language.

## Privacy

Pudim talks only to the servers you configure: your Jellyfin server and, if set, your extras server.
There is no analytics or telemetry. On Android, plain HTTP is allowed because home servers often use it on the
local network; prefer HTTPS for remote access.

## Contributing

Issues and pull requests are welcome. Please run `flutter analyze` and `flutter test` before opening a PR.

## License

[GPL-3.0](LICENSE). Pudim is not affiliated with the Jellyfin project.
