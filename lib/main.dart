// The new API (nativeapi) of window_manager 0.7 is still recent; we use the legacy bridge.
// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/legacy.dart';

import 'audio/windows_media_controls.dart';
import 'router.dart';
import 'l10n/l10n.dart';
import 'l10n/delegates.dart';
import 'state/app_theme.dart';
import 'state/locale.dart';
import 'state/session.dart';
import 'state/legacy_data.dart';
import 'ui/responsive.dart';
import 'ui/theme.dart';

import 'package:path_provider/path_provider.dart';

import 'api/response_cache.dart';
import 'ui/widgets/disk_image.dart';
import 'state/notify.dart';
import 'state/android_widget.dart';
import 'state/chat.dart';
import 'state/jam.dart';
import 'audio/player.dart';
import 'audio/carplay_bridge.dart';
import 'audio/media_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before reading settings: an older Windows build may have kept them in another folder.
  await migrateLegacyData();
  final prefs = await SharedPreferences.getInstance();
  // Notification and Android Auto strings before the first screen.
  final saved = prefs.getString('locale');
  appL10n = lookupL10n(
    saved != null && appLanguages.contains(saved)
        ? Locale(saved)
        : resolveAppLocale(PlatformDispatcher.instance.locales),
  );
  // On-device copies of screens and covers: the app opens and navigates without internet.
  final support = (await getApplicationSupportDirectory()).path;
  ResponseCache.instance = await ResponseCache.open(support);
  await DiskImage.init(support);
  await Notify.init();
  if (Platform.isAndroid || Platform.isIOS) {
    // Notification, lock screen and Bluetooth headphones.
    // This is also what shows up in Android Auto.
    await MediaSession.init();
    // CarPlay (iOS): the car's lists request the folders through this channel.
    if (Platform.isIOS) CarPlayBridge.init();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Pm.black,
      ),
    );
  } else {
    JustAudioMediaKit.prefetchPlaylist = true; // joins tracks without a gap
    JustAudioMediaKit.ensureInitialized();
    await initWindowsMediaControls();
  }
  if (isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(
      WindowOptions(
        title: 'Pudim',
        size: Size(1400, 880),
        minimumSize: Size(900, 600),
        center: true,
        backgroundColor: Pm.black,
        titleBarStyle: TitleBarStyle.hidden,
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
  final container = ProviderContainer(
    overrides: [prefsProvider.overrideWithValue(prefs)],
  );
  // The player is created right away: Android Auto can open the app without the UI showing.
  container.read(playerProvider.notifier);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PudimMusicApp(),
    ),
  );
}

class PudimMusicApp extends ConsumerWidget {
  const PudimMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (Platform.isWindows) ref.watch(windowsMediaControlsProvider);
    if (Platform.isAndroid) ref.watch(androidWidgetProvider);
    // Jam: rejoins the one the account was already in and keeps syncing.
    if (session.value != null && ref.watch(hasExtrasProvider)) {
      ref.watch(jamProvider);
      // Chat (and the Jam invites that arrive through it): polls from the start, not only once
      // the chat icon is on screen, so new messages become notifications.
      ref.listen(chatsProvider, (_, _) {});
    }
    final locale = ref.watch(localeProvider);
    final look = ref.watch(appThemeProvider);
    if (session.isLoading && !session.hasValue) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        localeListResolutionCallback: (device, _) => resolveAppLocale(device),
        builder: _keepL10n,
        theme: buildTheme(look),
        home: Scaffold(
          backgroundColor: Pm.black,
          body: Center(child: CircularProgressIndicator(color: Pm.accent)),
        ),
      );
    }
    return MaterialApp.router(
      title: 'Pudim',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(look),
      locale: locale,
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: (device, _) => resolveAppLocale(device),
      builder: _keepL10n,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// Keeps the current language's strings at hand for code that has no [BuildContext].
Widget _keepL10n(BuildContext context, Widget? child) {
  appL10n = L10n.of(context);
  return child ?? const SizedBox.shrink();
}
