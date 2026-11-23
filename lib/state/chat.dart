import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import 'notify.dart';
import 'session.dart';

/// Conversas desta conta (do painel), consultadas a cada 15 s (4 s com uma conversa aberta).
/// Mensagem nova de outra pessoa vira notificação, menos a da conversa que está aberta.
final chatsProvider = NotifierProvider<ChatsNotifier, ChatList>(
  ChatsNotifier.new,
);

class ChatsNotifier extends Notifier<ChatList> {
  Timer? _timer;
  int _lastId = -1;

  /// Conversa aberta agora (não notifica as mensagens dela).
  String? openWith;

  @override
  ChatList build() {
    ref.onDispose(() => _timer?.cancel());
    ref.watch(catalogProvider);
    _timer = Timer(const Duration(seconds: 3), refresh);
    return ChatList.empty;
  }

  Future<void> refresh() async {
    _timer?.cancel();
    try {
      final cat = ref.read(catalogProvider);
      if (cat.token.isNotEmpty) {
        final list = await cat.chats();
        final me = ref.read(sessionProvider).value?.userId;
        if (_lastId >= 0) {
          for (final c in list.chats) {
            final m = c.last;
            if (m.id > _lastId && m.from != me && c.user.id != openWith) {
              final what = m.share != null
                  ? 'Compartilhou ${m.share!.title}'
                  : m.text;
              Notify.show(
                0x40000000 + (c.user.id.hashCode & 0xFFFF),
                c.user.displayName,
                what,
              );
            }
          }
        }
        _lastId = list.lastId;
        state = list;
      }
    } catch (_) {}
    _timer = Timer(Duration(seconds: openWith != null ? 4 : 15), refresh);
  }
}
