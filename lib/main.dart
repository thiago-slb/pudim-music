// A API nova (nativeapi) do window_manager 0.7 ainda é recente; usamos a ponte legada.
// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/legacy.dart';

import 'audio/windows_media_controls.dart';
import 'router.dart';
import 'state/session.dart';
import 'ui/responsive.dart';
import 'ui/theme.dart';

import 'package:path_provider/path_provider.dart';

import 'api/response_cache.dart';
import 'ui/widgets/disk_image.dart';
import 'state/notify.dart';
import 'state/android_widget.dart';
import 'state/jam.dart';
import 'audio/player.dart';
import 'audio/media_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cópias no aparelho das telas e capas: o app abre e navega sem internet.
  final support = (await getApplicationSupportDirectory()).path;
  ResponseCache.instance = await ResponseCache.open(support);
  await DiskImage.init(support);
  await Notify.init();
  if (Platform.isAndroid || Platform.isIOS) {
    // Notificação, tela de bloqueio e fones Bluetooth.
    // Também é o que aparece no Android Auto.
    await MediaSession.init();
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
  final prefs = await SharedPreferences.getInstance();
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
    if (session.isLoading && !session.hasValue) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
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
      routerConfig: ref.watch(routerProvider),
    );
  }
}
