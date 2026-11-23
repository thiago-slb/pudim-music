import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/l10n.dart';

/// Notificações do sistema (Android e Windows): downloads no aparelho com barra de progresso,
/// músicas que chegaram na biblioteca e avisos do servidor (lançamentos, Descobertas, Mistura).
class Notify {
  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const offlineId = 1; // baixando no aparelho
  static const libraryId = 2; // baixando para a biblioteca

  static Future<void> init() async {
    if (!(Platform.isAndroid || Platform.isWindows)) return;
    try {
      await _p.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          windows: WindowsInitializationSettings(
            appName: 'Pudim',
            appUserModelId: 'io.github.thiagoslb.pudim',
            guid: '6f1d2c4e-3b7a-4f0e-9a51-2d8c7e5b9f13',
          ),
        ),
      );
      if (Platform.isAndroid) {
        await _p
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
      _ready = true;
    } catch (_) {
      // Sem notificações (permissão negada ou plataforma sem suporte): o app segue normal.
    }
  }

  /// Notificação fixa com barra (só no Android; no Windows fica só o aviso do fim).
  static Future<void> progress(
    int id,
    String title,
    String body, {
    int done = 0,
    int total = 0,
  }) async {
    if (!_ready || !Platform.isAndroid) return;
    try {
      await _p.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'downloads',
            appL10n.stateNotifyDownloadsChannel,
            channelDescription: appL10n.stateNotifyDownloadsChannelDesc,
            importance: Importance.low,
            priority: Priority.low,
            onlyAlertOnce: true,
            showWhen: false,
            ongoing: true,
            autoCancel: false,
            showProgress: true,
            maxProgress: total,
            progress: done,
            indeterminate: total == 0,
          ),
        ),
      );
    } catch (_) {}
  }

  /// Aviso comum (som normal).
  static Future<void> show(int id, String title, String body) async {
    if (!_ready) return;
    try {
      await _p.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'novidades',
            appL10n.stateNotifyNewsChannel,
            channelDescription: appL10n.stateNotifyNewsChannelDesc,
          ),
          windows: const WindowsNotificationDetails(),
        ),
      );
    } catch (_) {}
  }

  static Future<void> cancel(int id) async {
    if (!_ready) return;
    try {
      await _p.cancel(id: id);
    } catch (_) {}
  }
}
