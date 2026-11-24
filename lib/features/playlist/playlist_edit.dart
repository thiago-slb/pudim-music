import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';

import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/library.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/user_photo.dart';
import '../chat/chat_pages.dart';

/// Playlists the panel builds on its own (can't be edited by hand: they would be rewritten).
bool isGeneratedPlaylist(String name) =>
    name.startsWith('Descobertas da semana') ||
    name == 'Mistura da semana' ||
    name == 'Radar de Novidades' ||
    name.startsWith('daylist · ') ||
    name.startsWith('Blend · ') ||
    name.startsWith('Spotify · ') ||
    name.endsWith('_automatic');

/// A playlist's page: data and tracks (public so it can refresh after editing).
class PlaylistData {
  final Item playlist;
  final List<Item> tracks;
  PlaylistData(this.playlist, this.tracks);
}

final playlistProvider = FutureProvider.autoDispose
    .family<PlaylistData, String>((ref, id) async {
      final api = ref.watch(apiProvider);
      final r = await Future.wait([api.item(id), api.playlistTracks(id)]);
      return PlaylistData(r[0] as Item, r[1] as List<Item>);
    });

/// Who takes part and who added each song (from the panel; empty if not collaborative).
final collabProvider = FutureProvider.autoDispose.family<CollabInfo, String>((
  ref,
  pid,
) async {
  try {
    return await ref.watch(catalogProvider).collab(pid);
  } catch (_) {
    return CollabInfo.none;
  }
});

String _err(Object e) {
  if (e is DioException) {
    final code = e.response?.statusCode;
    if (code == 403 || code == 401) {
      return appL10n.playlistErrNoPermission;
    }
    return appL10n.playlistErrServer(
      code?.toString() ?? appL10n.playlistErrNoResponse,
    );
  }
  return '$e';
}

void _refresh(WidgetRef ref, String pid) {
  ref.invalidate(playlistProvider(pid));
  ref.invalidate(collabProvider(pid));
  ref.invalidate(libraryProvider);
}

/// "Add to playlist": picks (or creates) one and adds the library tracks.
Future<void> addToPlaylistSheet(
  BuildContext context,
  WidgetRef ref,
  List<Item> tracks,
) async {
  final ids = [
    for (final t in tracks)
      if (!t.isCatalog && !t.isPodcast) t.id,
  ];
  if (ids.isEmpty) {
    toast(context, context.l10n.playlistDownloadFirst);
    return;
  }
  final lib = await ref.read(libraryProvider.future);
  if (!context.mounted) return;
  final mine = lib.playlists
      .where((p) => !isGeneratedPlaylist(p.name))
      .toList();
  final picked = await showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Pm.elevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (sheet) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(sheet).height * 0.75,
      ),
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                sheet.l10n.playlistAddTo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Pm.highlight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.add, color: Pm.text),
              ),
              title: Text(sheet.l10n.playlistNew),
              onTap: () => Navigator.pop(sheet, ''),
            ),
            for (final p in mine)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Cover(p, size: 44),
                title: Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: p.childCount == null
                    ? null
                    : Text(
                        sheet.l10n.commonSongCount(p.childCount!),
                        style: TextStyle(color: Pm.subdued, fontSize: 12.5),
                      ),
                onTap: () => Navigator.pop(sheet, p.id),
              ),
          ],
        ),
      ),
    ),
  );
  if (picked == null || !context.mounted) return;
  if (picked.isEmpty) {
    await newPlaylistDialog(context, ref, tracks: tracks);
    return;
  }
  final name = mine.firstWhere((p) => p.id == picked).name;
  try {
    await ref.read(apiProvider).addToPlaylist(picked, ids);
    ref.read(catalogProvider).collabAdded(picked, ids).catchError((_) {});
    _refresh(ref, picked);
    if (context.mounted) toast(context, context.l10n.playlistAddedTo(name));
  } catch (e) {
    if (context.mounted) toast(context, _err(e));
  }
}

/// Asks for the name and creates the playlist (with the tracks, if any); opens its page.
Future<void> newPlaylistDialog(
  BuildContext context,
  WidgetRef ref, {
  List<Item> tracks = const [],
}) async {
  final ctl = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Pm.elevated,
      title: Text(ctx.l10n.playlistNew),
      content: TextField(
        controller: ctl,
        autofocus: true,
        maxLength: 100,
        decoration: InputDecoration(hintText: ctx.l10n.playlistNameHint),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(ctx.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctl.text.trim()),
          child: Text(ctx.l10n.playlistCreate),
        ),
      ],
    ),
  );
  if (name == null || name.isEmpty || !context.mounted) return;
  try {
    final ids = [
      for (final t in tracks)
        if (!t.isCatalog && !t.isPodcast) t.id,
    ];
    final pid = await ref.read(apiProvider).createPlaylist(name, ids);
    if (ids.isNotEmpty) {
      ref.read(catalogProvider).collabAdded(pid, ids).catchError((_) {});
    }
    ref.invalidate(libraryProvider);
    if (context.mounted) {
      toast(context, context.l10n.playlistCreated(name));
      context.go('/playlist/$pid');
    }
  } catch (e) {
    if (context.mounted) toast(context, _err(e));
  }
}

Future<void> removeFromPlaylist(
  BuildContext context,
  WidgetRef ref,
  String pid,
  Item t,
) async {
  final entry = t.playlistItemId;
  if (entry == null) return;
  try {
    await ref.read(apiProvider).removeFromPlaylist(pid, [entry]);
    _refresh(ref, pid);
    if (context.mounted) toast(context, context.l10n.playlistRemoved);
  } catch (e) {
    if (context.mounted) toast(context, _err(e));
  }
}

/// Invites another account to edit (Jellyfin only accepts this from the playlist owner).
Future<void> inviteToEdit(
  BuildContext context,
  WidgetRef ref,
  Item playlist,
) async {
  final c = await pickContact(
    context,
    title: context.l10n.playlistInviteTitle,
    subtitle: context.l10n.playlistInviteSubtitle,
  );
  if (c == null || !context.mounted) return;
  try {
    await ref.read(apiProvider).sharePlaylist(playlist.id, c.id, canEdit: true);
  } catch (e) {
    if (context.mounted) {
      toast(context, context.l10n.playlistInviteOwnerOnly);
    }
    return;
  }
  try {
    await ref
        .read(catalogProvider)
        .collabInvite(playlist.id, c.id, playlist.name);
  } catch (_) {
    // no panel: the Jellyfin permission already applies; there is just no invite in the chat
  }
  ref.invalidate(collabProvider(playlist.id));
  if (context.mounted) {
    toast(context, context.l10n.playlistInvited(c.displayName, playlist.name));
  }
}

/// "Collaborative · photos of participants", in the playlist header.
class CollabMembers extends ConsumerWidget {
  final String pid;
  const CollabMembers(this.pid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasExtrasProvider)) return const SizedBox.shrink();
    final info = ref.watch(collabProvider(pid)).value;
    if (info == null || !info.isCollab) return const SizedBox.shrink();
    final shown = info.members.take(5).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22.0 + (shown.length - 1) * 16,
            height: 24,
            child: Stack(
              children: [
                for (var i = 0; i < shown.length; i++)
                  Positioned(
                    left: i * 16.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Pm.base, width: 1.5),
                      ),
                      child: UserPhoto(
                        userId: shown[i].id,
                        name: shown[i].displayName,
                        tag: shown[i].image,
                        size: 22,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              context.l10n.playlistCollaborative(
                info.members.map((m) => m.displayName).join(', '),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Pm.subdued, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Smart Shuffle in the playlist bar: shuffle with recommendations mixed in.
class SmartShuffleButton extends ConsumerWidget {
  final List<Item> tracks;
  final String title, route;
  const SmartShuffleButton({
    super.key,
    required this.tracks,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(
      playerProvider.select((q) => q.smart && q.contextRoute == route),
    );
    return IconBtn(
      Icons.auto_awesome,
      tooltip: context.l10n.playlistSmartShuffleTooltip,
      size: 26,
      active: on,
      onPressed: () {
        ref
            .read(playerProvider.notifier)
            .smartShufflePlay(tracks, contextName: title, contextRoute: route);
        toast(context, context.l10n.playlistSmartShuffleOn);
      },
    );
  }
}

/// Smart Shuffle recommendation currently playing: button to add it to the playlist for good.
Future<void> keepRecommendation(
  BuildContext context,
  WidgetRef ref,
  Item t,
) async {
  final pid = ref.read(playerProvider).contextPlaylistId;
  if (pid == null) return;
  try {
    await ref.read(apiProvider).addToPlaylist(pid, [t.id]);
    ref.read(catalogProvider).collabAdded(pid, [t.id]).catchError((_) {});
    ref.read(playerProvider.notifier).acceptRecommendation(t.id);
    _refresh(ref, pid);
    if (context.mounted) toast(context, context.l10n.playlistAddedToThis);
  } catch (e) {
    if (context.mounted) toast(context, _err(e));
  }
}

/// "✦ Recommendation" below the controls when the song came from Smart Shuffle.
class RecommendationBar extends ConsumerWidget {
  final Item track;
  const RecommendationBar(this.track, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
    decoration: BoxDecoration(
      color: Pm.highlight,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        Icon(Icons.auto_awesome, size: 16, color: Pm.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.l10n.playlistRecommendation,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        TextButton(
          onPressed: () => keepRecommendation(context, ref, track),
          child: Text(context.l10n.playlistPutIn),
        ),
      ],
    ),
  );
}
