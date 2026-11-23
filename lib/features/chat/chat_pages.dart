import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../api/models.dart';
import '../../state/chat.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/user_photo.dart';
import '../../state/jam.dart';
import '../../l10n/l10n.dart';
import 'blend.dart';

final contactsProvider = FutureProvider.autoDispose<List<Contact>>(
  (ref) => ref.watch(catalogProvider).contacts(),
);

class _Avatar extends StatelessWidget {
  final Contact? c;
  final double size;
  const _Avatar(this.c, {this.size = 44});
  @override
  Widget build(BuildContext context) => UserPhoto(
    userId: c?.id ?? '',
    name: c?.displayName ?? '',
    tag: c?.image,
    size: size,
  );
}

String _when(DateTime t) {
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  if (now.year == t.year && now.month == t.month && now.day == t.day) {
    return '${two(t.hour)}:${two(t.minute)}';
  }
  return '${two(t.day)}/${two(t.month)}';
}

/// Chat icon in the bar (with the unread count).
class ChatButton extends ConsumerWidget {
  const ChatButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    final n = ref.watch(chatsProvider.select((c) => c.unread));
    return IconButton(
      tooltip: context.l10n.chatChats,
      onPressed: () => context.push('/chat'),
      icon: Badge(
        isLabelVisible: n > 0,
        backgroundColor: Pm.green,
        textColor: Colors.black,
        label: Text('$n'),
        child: const Icon(Icons.chat_bubble_outline, color: Pm.subdued),
      ),
    );
  }
}

// ------------------------------------------------------------------ conversation list

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider).chats;
    final contacts = ref.watch(contactsProvider);
    final talked = {for (final c in chats) c.user.id};
    final others = (contacts.value ?? const <Contact>[])
        .where((c) => !talked.contains(c.id))
        .toList();
    final side = isCompact(context) ? 16.0 : 32.0;
    final me = ref.watch(sessionProvider).value?.userId;
    return Container(
      color: Pm.base,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(contactsProvider);
          await ref.read(chatsProvider.notifier).refresh();
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            side,
            isCompact(context) ? 64 : 24,
            side,
            160,
          ),
          children: [
            Text(
              context.l10n.chatChats,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            for (final c in chats)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _Avatar(c.user),
                title: Text(
                  c.user.displayName,
                  style: TextStyle(
                    fontWeight: c.unread > 0
                        ? FontWeight.w800
                        : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  c.last.from == me
                      ? context.l10n.chatYouSaid(
                          c.last.share != null
                              ? '🎵 ${c.last.share!.title}'
                              : c.last.text,
                        )
                      : (c.last.share != null
                            ? '🎵 ${c.last.share!.title}'
                            : c.last.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: c.unread > 0 ? Pm.text : Pm.subdued),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _when(c.last.at),
                      style: const TextStyle(color: Pm.muted, fontSize: 12),
                    ),
                    if (c.unread > 0)
                      Badge(
                        backgroundColor: Pm.green,
                        textColor: Colors.black,
                        label: Text('${c.unread}'),
                      ),
                  ],
                ),
                onTap: () => context.push('/chat/${c.user.id}'),
              ),
            if (others.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                context.l10n.chatContacts,
                style: const TextStyle(
                  color: Pm.subdued,
                  fontWeight: FontWeight.w700,
                ),
              ),
              for (final c in others)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _Avatar(c),
                  title: Text(c.displayName),
                  subtitle: c.displayName != c.name
                      ? Text(c.name, style: const TextStyle(color: Pm.muted))
                      : null,
                  onTap: () => context.push('/chat/${c.id}'),
                ),
            ],
            if (contacts.hasError && chats.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  context.l10n.chatServerUnreachable,
                  style: const TextStyle(color: Pm.subdued),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ a conversation

class ChatThreadPage extends ConsumerStatefulWidget {
  final String userId;
  const ChatThreadPage(this.userId, {super.key});
  @override
  ConsumerState<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends ConsumerState<ChatThreadPage> {
  final _msgs = <ChatMessage>[];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  Contact? _user;
  Timer? _timer;
  bool _sending = false;
  late final ChatsNotifier _chats;

  @override
  void initState() {
    super.initState();
    _chats = ref.read(chatsProvider.notifier)..openWith = widget.userId;
    _poll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chats.openWith = null;
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _poll() async {
    _timer?.cancel();
    try {
      final after = _msgs.isEmpty ? 0 : _msgs.last.id;
      final (u, list) = await ref
          .read(catalogProvider)
          .chat(widget.userId, after: after);
      if (!mounted) return;
      final had = _msgs.length;
      setState(() {
        _user = u;
        _msgs.addAll(list.where((m) => !_msgs.any((x) => x.id == m.id)));
      });
      if (_msgs.length != had) {
        _toBottom();
        unawaited(_chats.refresh());
      }
    } catch (_) {}
    if (mounted) _timer = Timer(const Duration(seconds: 4), _poll);
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  });

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final m = await ref
          .read(catalogProvider)
          .sendChat(widget.userId, text: text);
      _input.clear();
      setState(() => _msgs.add(m));
      _toBottom();
      unawaited(_chats.refresh());
    } catch (e) {
      if (mounted) toast(context, '$e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(sessionProvider).value?.userId;
    final compact = isCompact(context);
    final name = _user?.displayName ?? '';
    return Container(
      color: Pm.base,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 64 : 32,
              compact ? 14 : 20,
              16,
              10,
            ),
            child: Row(
              children: [
                _Avatar(_user, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (_user != null) BlendButton(_user!),
              ],
            ),
          ),
          const Divider(height: 1, color: Pm.highlight),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              itemCount: _msgs.length,
              itemBuilder: (_, i) {
                final m = _msgs[i];
                final mine = m.from == me;
                return Align(
                  alignment: mine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                      decoration: BoxDecoration(
                        color: mine ? const Color(0xFF1B4D2E) : Pm.elevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.share != null) SharedCard(m.share!),
                          if (m.text.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                top: m.share != null ? 6 : 0,
                              ),
                              child: SelectableText(m.text),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _when(m.at),
                              style: const TextStyle(
                                color: Pm.muted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              // On phones the player bar sits on top: raise the field.
              padding: EdgeInsets.fromLTRB(12, 6, 8, compact ? 150 : 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: context.l10n.chatMessageHint,
                        filled: true,
                        fillColor: Pm.elevated,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send, color: Pm.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for what was shared; tapping opens the page (or plays the song).
class SharedCard extends ConsumerWidget {
  final SharedItem s;
  const SharedCard(this.s, {super.key});

  Item _coverItem() {
    final kind = switch (s.kind) {
      'album' => ItemKind.album,
      'artist' => ItemKind.artist,
      'playlist' => ItemKind.playlist,
      _ => ItemKind.track,
    };
    if (s.cover.startsWith('http')) {
      catalogCovers[s.id] = s.cover;
      return Item(id: s.id, name: s.title, kind: kind, primaryTag: 'dz');
    }
    final img = s.cover.startsWith('jf:') ? s.cover.substring(3) : s.id;
    return Item(
      id: img,
      name: s.title,
      kind: kind == ItemKind.track ? ItemKind.album : kind,
      primaryTag: 'jf',
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    switch (s.kind) {
      case 'jam':
        try {
          await ref.read(jamProvider.notifier).join(s.id);
          if (context.mounted) {
            toast(context, context.l10n.chatJoinedJam(s.title));
          }
        } catch (e) {
          if (context.mounted) toast(context, '$e');
        }
      case 'album':
        context.push('/album/${s.id}');
      case 'artist':
        context.push('/artist/${s.id}');
      case 'playlist':
        context.push('/playlist/${s.id}');
      default:
        try {
          final it = isCatalogId(s.id)
              ? Item(
                  id: s.id,
                  name: s.title,
                  kind: ItemKind.track,
                  cloud: true,
                  artists: [NameId('', s.subtitle)],
                )
              : await ref.read(apiProvider).item(s.id);
          await playItem(ref, it);
        } catch (e) {
          if (context.mounted) {
            toast(context, context.l10n.chatCouldNotPlay('$e'));
          }
        }
    }
  }

  Widget _jamCard(BuildContext context, WidgetRef ref) {
    final inIt = ref.watch(jamProvider.select((j) => j?.id == s.id));
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF1ED760)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  context.l10n.chatJamCardSubtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: inIt ? null : () => _open(context, ref),
            child: Text(inIt ? context.l10n.chatInJam : context.l10n.chatJoin),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = switch (s.kind) {
      'album' => context.l10n.commonAlbum,
      'artist' => context.l10n.commonArtist,
      'playlist' => context.l10n.commonPlaylist,
      'jam' => 'Jam',
      _ => context.l10n.commonSong,
    };
    if (s.kind == 'jam') return _jamCard(context, ref);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _open(context, ref),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Cover(_coverItem(), size: 52, round: s.kind == 'artist'),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    [label, if (s.subtitle.isNotEmpty) s.subtitle].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Pm.subdued, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              s.kind == 'track' ? Icons.play_circle : Icons.chevron_right,
              color: Pm.subdued,
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ share

/// Pick another account on the server (invites: edit playlist, Jam, Blend).
Future<Contact?> pickContact(
  BuildContext context, {
  required String title,
  String? subtitle,
}) => showModalBottomSheet<Contact>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: Pm.elevated,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  ),
  builder: (sheet) => Consumer(
    builder: (_, ref, _) {
      final contacts = ref.watch(contactsProvider);
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheet).height * 0.7,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Pm.subdued)),
                ],
                const SizedBox(height: 12),
                Flexible(
                  child: contacts.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) =>
                        Text('$e', style: const TextStyle(color: Pm.subdued)),
                    data: (list) => list.isEmpty
                        ? Text(
                            context.l10n.chatNoOtherAccounts,
                            style: const TextStyle(color: Pm.subdued),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children: [
                              for (final c in list)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: _Avatar(c, size: 38),
                                  title: Text(c.displayName),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: Pm.subdued,
                                  ),
                                  onTap: () => Navigator.pop(sheet, c),
                                ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);

SharedItem sharedOf(Item it) {
  final cover = isCatalogId(it.id)
      ? (catalogCovers[it.id] ?? catalogCovers[it.albumId] ?? '')
      : (it.imageItemId == null ? '' : 'jf:${it.imageItemId}');
  final kind = switch (it.kind) {
    ItemKind.album => 'album',
    ItemKind.artist => 'artist',
    ItemKind.playlist => 'playlist',
    _ => 'track',
  };
  final sub = switch (it.kind) {
    ItemKind.artist => '',
    ItemKind.playlist =>
      it.childCount != null ? appL10n.chatSongsCount(it.childCount!) : '',
    _ => it.artistLine,
  };
  return SharedItem(kind, it.id, it.name, sub, cover);
}

/// Pick a contact and send the page (with an optional note).
Future<void> shareItem(BuildContext context, WidgetRef ref, Item it) async {
  final share = sharedOf(it);
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Pm.elevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (sheet) => _ShareSheet(share),
  );
}

class _ShareSheet extends ConsumerStatefulWidget {
  final SharedItem share;
  const _ShareSheet(this.share);
  @override
  ConsumerState<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends ConsumerState<_ShareSheet> {
  final _note = TextEditingController();
  String? _sendingTo;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _send(Contact c) async {
    setState(() => _sendingTo = c.id);
    if (widget.share.kind == 'playlist' && !isCatalogId(widget.share.id)) {
      // only the owner can grant access in Jellyfin; if not, the person already has access another way
      // or won't
      try {
        await ref.read(apiProvider).sharePlaylist(widget.share.id, c.id);
      } catch (_) {}
    }
    try {
      await ref
          .read(catalogProvider)
          .sendChat(c.id, text: _note.text.trim(), share: widget.share);
      unawaited(ref.read(chatsProvider.notifier).refresh());
      if (mounted) {
        Navigator.of(context).pop();
        toast(context, context.l10n.chatSentTo(c.displayName));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sendingTo = null);
        toast(context, '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            12 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.chatShareTitle(widget.share.title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _note,
                decoration: InputDecoration(
                  hintText: context.l10n.chatNoteHint,
                  filled: true,
                  fillColor: Pm.highlight,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: contacts.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) =>
                      Text('$e', style: const TextStyle(color: Pm.subdued)),
                  data: (list) => list.isEmpty
                      ? Text(
                          context.l10n.chatNoOtherAccounts,
                          style: const TextStyle(color: Pm.subdued),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            for (final c in list)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: _Avatar(c, size: 38),
                                title: Text(c.displayName),
                                trailing: _sendingTo == c.id
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.send, color: Pm.green),
                                onTap: _sendingTo == null
                                    ? () => _send(c)
                                    : null,
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
