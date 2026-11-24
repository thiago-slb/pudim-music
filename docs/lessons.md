# Lessons learned

Bugs that reached real devices, why they happened and what now keeps them from coming back.

## Gray screens in every language but English (builds 8-11)

**Symptom.** On a phone set to Portuguese the home screen and then the login form were plain gray
boxes. Desktop in English looked fine.

**Cause.** The widgets come from `package:material_ui`, which has its own `MaterialLocalizations`
type. The app registered `L10n.localizationsDelegates`, whose Material delegate comes from
`flutter_localizations` and provides the *framework's* type. material_ui's `TextField`, tooltips and
dialogs did not find theirs; English worked only because of the built-in English fallback. In release
builds the "No MaterialLocalizations found" error is drawn as a gray `ErrorWidget`.

**Fix.** `lib/l10n/delegates.dart` (`appLocalizationsDelegates`): the app's strings plus
`GlobalMaterialLocalizations.delegates` from material_ui. Use it for every `MaterialApp`.

**Guard.** `test/locales_render_test.dart` renders Material widgets in every supported locale and
fails on any exception (it fails for 14 of 15 languages with the old list). Runs in CI.

## Gray screen on Android at startup (build 9)

**Cause.** `PlayerController.build()` called `MediaSession.attach`, which reads the player's
`state`. Reading a Notifier's own state inside `build()` throws "uninitialized provider", so the player
provider failed and every widget watching it (mini player, home) failed too. The media session only
exists on Android and iOS, so desktop never showed it.

**Fix.** Attach in a microtask after `build()` returns.

**Rule.** Never read `state` (directly or through a helper) inside a Notifier's `build()`. When
something only runs on mobile, try it on an emulator before publishing (`flutter run -d emulator-5554`
shows the stack traces that release builds hide).

## Android Auto showed the previous track (build 12)

**Cause.** The media item was pushed only when the queue's current index changed. With gapless
playback the player switches sources by itself and `_autoAdvanced` moves the queue; when that event
arrived while the next track was being prepared (`_busy`), it was dropped, so the queue, notification
and car display stayed on the old track.

**Fix.** The busy case retries; the media session also listens to `currentIndexStream` and shows the
source that is actually playing when it is the queue's next track.

**Still to verify in a car:** automatic advance, skipping from the phone and from the car buttons,
and the app icon in the Android Auto launcher (clear Android Auto's cache if an old icon sticks).

## The same track played twice at the end (build 14)

**Cause.** Same root as build 12: the player switched to the preloaded track by itself and the queue
did not follow (the `autoAdvance` discontinuity was missed, or the retry ran out). Build 12 only
hid this on the car display. When that track ended, the queue was still one behind, so `next()`
loaded the track that had just finished.

**Fix.** `catchUpIndex` (in `player.dart`) says where the queue should be given the track the player
is on. It is used when the player's current index changes (a second signal besides the
discontinuity), in `_autoAdvanced` when `_preId` is stale, and when a track ends, before choosing the
next one. Guard: `test/queue_catch_up_test.dart`.

## Windows data folder moved (build 8)

**Cause.** The Windows data folder is `%APPDATA%\<CompanyName>\<ProductName>` from
`windows/runner/Runner.rc`. Changing CompanyName moved it, so an update started logged out and empty.

**Fix.** `PUDIM_LEGACY_DATA_DIR` (build define) names the old folder; the first launch copies it.

**Rule.** Do not change CompanyName/ProductName (Windows) or the application id (Android) of a
published build without a migration: the id change installs a second app, the folder change loses data.
