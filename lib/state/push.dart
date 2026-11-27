import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import '../router.dart';
import 'session.dart';

/// Push on Android (Firebase Cloud Messaging, native side in MainActivity): registers this phone's
/// token with the extras server, so chat messages and Jam invites arrive even with the app closed.
/// Tapping one opens the conversation. Builds without the Firebase ids just have no push.
class Push {
  static const _ch = MethodChannel('pudim/push');

  /// The server confirmed it can send pushes to this phone (then the chat poll stays quiet in the
  /// background, so the same message does not notify twice).
  static bool active = false;

  static Future<String?> token() async {
    if (!Platform.isAndroid) return null;
    try {
      return await _ch.invokeMethod<String>('token');
    } catch (_) {
      return null;
    }
  }
}

final pushProvider = Provider<void>((ref) {
  if (!Platform.isAndroid) return;
  final cat = ref.watch(catalogProvider);
  if (cat.token.isEmpty) return;
  unawaited(() async {
    final t = await Push.token();
    if (t == null || !ref.mounted) return;
    try {
      Push.active = await cat.pushToken(t);
    } catch (_) {}
  }());

  void open(String? route) {
    if (route == null || !route.startsWith('/')) return;
    ref.read(routerProvider).push(route);
  }

  Push._ch.setMethodCallHandler((call) async {
    if (call.method == 'open') open(call.arguments as String?);
  });
  unawaited(
    Push._ch
        .invokeMethod<String>('initialRoute')
        .then(open, onError: (_) {}),
  );
  ref.onDispose(() => Push._ch.setMethodCallHandler(null));
});
