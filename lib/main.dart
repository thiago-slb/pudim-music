// A API nova (nativeapi) do window_manager 0.7 ainda é recente; usamos a ponte legada.
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
import 'state/jam.dart';
import 'audio/player.dart';
import 'audio/carplay_bridge.dart';
import 'audio/media_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before reading settings: an older Windows build may have kept them in another folder.
  await migrateLegacyData();
  final prefs = await SharedPreferences.getInstance();
  // Textos das notificações e do Android Auto antes da primeira tela.
  final saved = prefs.getString('locale');
  appL10n = lookupL10n(
    saved != null && appLanguages.contains(saved)
        ? Locale(saved)
        : resolveAppLocale(PlatformDispatcher.instance.locales),
  );
  // Cópias no aparelho das telas e capas: o app abre e navega sem internet.
  final support = (await getApplicationSupportDirectory()).path;
  ResponseCache.instance = await ResponseCache.open(support);
  await DiskImage.init(support);
  await Notify.init();
  if (Platform.isAndroid || Platform.isIOS) {
    // Notificação, tela de bloqueio e fones Bluetooth.
    // Também é o que aparece no Android Auto.
    await MediaSession.init();
    // CarPlay (iOS): as listas do carro pedem as pastas por este canal.
    if (Platform.isIOS) CarPlayBridge.init();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Pm.black,
      ),
    );
  } else {
    JustAudioMediaKit.prefetchPlaylist = true; // emenda as faixas sem pausa
    JustAudioMediaKit.ensureInitialized();
    await initWindowsMediaControls();
  }
  if (isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
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
  // O player nasce já: o Android Auto pode abrir o app sem a tela aparecer.
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
    // Jam: volta para a que a conta já estava e continua sincronizando.
    if (session.value != null && ref.watch(hasExtrasProvider)) {
      ref.watch(jamProvider);
    }
    final locale = ref.watch(localeProvider);
    if (session.isLoading && !session.hasValue) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: _delegates,
        supportedLocales: L10n.supportedLocales,
        localeListResolutionCallback: (device, _) => resolveAppLocale(device),
        builder: _keepL10n,
        theme: buildTheme(),
        home: const Scaffold(
          backgroundColor: Pm.black,
          body: Center(child: CircularProgressIndicator(color: Pm.green)),
        ),
      );
    }
    return MaterialApp.router(
      title: 'Pudim',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: locale,
      localizationsDelegates: _delegates,
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: (device, _) => resolveAppLocale(device),
      builder: _keepL10n,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// The widgets come from package:material_ui, so the Material texts must come from its delegates
/// too. L10n.localizationsDelegates brings flutter_localizations' Material delegate, which material_ui's
/// TextField does not see: every language other than English failed with "No MaterialLocalizations"
/// and the screens went gray.
const _delegates = <LocalizationsDelegate<dynamic>>[
  L10n.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// Deixa os textos do idioma atual à mão para o código que não tem [BuildContext].
Widget _keepL10n(BuildContext context, Widget? child) {
  appL10n = L10n.of(context);
  return child ?? const SizedBox.shrink();
}
