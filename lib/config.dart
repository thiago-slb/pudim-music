/// Default addresses of the app.
///
/// The open-source code ships with no server: users type the Jellyfin address on the sign-in screen.
/// For a custom build to come with your addresses pre-filled, copy `pudim.example.json` to
/// `pudim.local.json` (kept out of git) and build with `--dart-define-from-file=pudim.local.json`.
library;

/// Main Jellyfin address (the one that works from any network), e.g. `https://jellyfin.example.com`.
const defaultServerUrl = String.fromEnvironment('PUDIM_SERVER_URL');

/// Jellyfin address on the local network (optional). When it responds, the app uses it instead of the main one.
const defaultLanUrl = String.fromEnvironment('PUDIM_SERVER_LAN_URL');

/// Pudim extras server (optional): chat, Jam, Blend, mixes, Year in Review, shows, podcasts,
/// Last.fm, download requests and automatic updates. Without it, the app is a full Jellyfin player.
const defaultExtrasUrl = String.fromEnvironment('PUDIM_EXTRAS_URL');
