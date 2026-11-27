import 'dart:async';

import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import 'notify.dart';
import 'session.dart';
import '../l10n/l10n.dart';

/// Conversations of this account (from the panel), polled every 15 s (4 s with a conversation open).
/// A new message from someone else becomes a notification, except in the conversation that is open.
final chatsProvider = NotifierProvider<ChatsNotifier, ChatList>(
  ChatsNotifier.new,
);

class ChatsNotifier extends Notifier<ChatList> {
  Timer? _timer;
  int _lastId = -1;

  /// Conversation open right now (its messages do not notify).
  String? openWith;

  @override
  ChatList build() {
    // Back to the app: checks right away (Jam invites sent while it was in the background).
    final life = AppLifecycleListener(onResume: () => unawaited(refresh()));
    ref.onDispose(() {
      _timer?.cancel();
      life.dispose();
    });
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
                  ? appL10n.stateChatShared(m.share!.title)
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
