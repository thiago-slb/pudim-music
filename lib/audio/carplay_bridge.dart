import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';

import 'media_session.dart';

/// Ponte com o CarPlay (iOS). A parte nativa (`ios/Runner/CarPlaySceneDelegate.swift`) só desenha
/// as listas do carro; as pastas e o "tocar" vêm da mesma navegação do Android Auto
/// ([MediaSession.getChildren] e [MediaSession.playFromMediaId]).
///
/// Métodos do canal `pudim/carplay`:
/// - `children(String parentId)` → lista de `{id, title, subtitle, art, playable}`;
///   `parentId` "root" devolve as pastas do topo.
/// - `play(String id)` → toca a faixa (com a pasta inteira como fila).
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
