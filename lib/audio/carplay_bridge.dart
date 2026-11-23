import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';

import 'media_session.dart';

/// Bridge to CarPlay (iOS). The native part (`ios/Runner/CarPlaySceneDelegate.swift`) only draws
/// the car's lists; the folders and "play" come from the same navigation as Android Auto
/// ([MediaSession.getChildren] and [MediaSession.playFromMediaId]).
///
/// Methods of the `pudim/carplay` channel:
/// - `children(String parentId)` → list of `{id, title, subtitle, art, playable}`;
///   `parentId` "root" returns the top-level folders.
/// - `play(String id)` → plays the track (with the whole folder as the queue).
class CarPlayBridge {
  static const _channel = MethodChannel('pudim/carplay');

  static void init() {
    _channel.setMethodCallHandler((call) async {
      final s = MediaSession.instance;
      if (s == null) return null;
      switch (call.method) {
        case 'children':
          final parent = call.arguments as String? ?? 'root';
          final items = await s.getChildren(
            parent == 'root' ? AudioService.browsableRootId : parent,
          );
          return [
            for (final m in items)
              {
                'id': m.id,
                'title': m.title,
                'subtitle': m.artist ?? m.album ?? '',
                'art': m.artUri?.toString(),
                'playable': m.playable ?? false,
              },
          ];
        case 'play':
          await s.playFromMediaId(call.arguments as String);
          return true;
      }
      throw MissingPluginException(call.method);
    });
  }
}
