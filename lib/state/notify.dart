import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/l10n.dart';

/// System notifications (Android and Windows): on-device downloads with a progress bar,
/// songs that arrived in the library and server notices (releases, Descobertas, Mistura).
class Notify {
  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const chatChannel = 'conversas';
  static const offlineId = 1; // downloading to the device
  static const libraryId = 2; // downloading to the library

  static Future<void> init() async {
    if (!(Platform.isAndroid || Platform.isWindows || Platform.isMacOS)) {
      return;
    }
    try {
      await _p.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_stat_pudim'),
          macOS: DarwinInitializationSettings(),
          windows: WindowsInitializationSettings(
            appName: 'Pudim',
            appUserModelId: 'io.github.thiagoslb.pudim',
            guid: '6f1d2c4e-3b7a-4f0e-9a51-2d8c7e5b9f13',
          ),
        ),
      );
      if (Platform.isAndroid) {
        final android = _p
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await android?.requestNotificationsPermission();
        // Also used by the pushes that arrive with the app closed (see AndroidManifest).
        await android?.createNotificationChannel(
          AndroidNotificationChannel(
            chatChannel,
            appL10n.stateNotifyChatChannel,
            description: appL10n.stateNotifyChatChannelDesc,
            importance: Importance.high,
          ),
        );
      }
      _ready = true;
    } catch (_) {
      // No notifications (permission denied or unsupported platform): the app carries on normally.
    }
  }

  /// Pinned notification with a bar (Android only; on Windows only the end notice).
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

  /// Plain notice (normal sound).
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
          macOS: const DarwinNotificationDetails(),
          windows: const WindowsNotificationDetails(),
        ),
      );
    } catch (_) {}
  }

  /// New chat message (or Jam invite) from [uid]. Same tag as the push for that conversation, so the
  /// two replace each other instead of showing twice.
  static Future<void> chat(String uid, String title, String body) async {
    if (!_ready) return;
    try {
      await _p.show(
        id: Platform.isAndroid ? 0 : 0x40000000 + (uid.hashCode & 0xFFFF),
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            chatChannel,
            appL10n.stateNotifyChatChannel,
            channelDescription: appL10n.stateNotifyChatChannelDesc,
            importance: Importance.high,
            priority: Priority.high,
            tag: 'chat-$uid',
          ),
          macOS: const DarwinNotificationDetails(),
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
