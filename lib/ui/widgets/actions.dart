import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/downloads.dart';
import '../../state/library.dart';
import '../../state/offline.dart';
import '../../state/session.dart';
import '../../l10n/l10n.dart';
import '../responsive.dart';
import '../theme.dart';
import 'common.dart';
import '../../state/quality.dart';
import '../../features/chat/chat_pages.dart';
import '../../api/catalog.dart';
import '../../features/playlist/playlist_edit.dart';

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        width: 360,
        duration: const Duration(seconds: 2),
      ),
    );
}

String routeFor(Item it) => switch (it.kind) {
  ItemKind.album => '/album/${it.id}',
  ItemKind.artist => '/artist/${it.id}',
  ItemKind.playlist => '/playlist/${it.id}',
  ItemKind.track =>
    (it.albumId ?? '').startsWith('podshow')
        ? '/podcast/${it.albumId!.substring(7)}'
        : it.albumId != null
        ? '/album/${it.albumId}'
        : '/',
  ItemKind.other => '/',
};

/// Tracks of an album/playlist/artist (or the track itself).
Future<List<Item>> tracksOf(WidgetRef ref, Item it) async {
  if (it.isCatalog && it.kind != ItemKind.track) {
    final cat = ref.read(catalogProvider);
    final n = it.deezerId!;
    return switch (it.kind) {
      ItemKind.album => (await cat.album(n)).tracks,
      ItemKind.playlist => (await cat.playlist(n)).tracks,
      ItemKind.artist => (await cat.artist(id: n)).top,
      _ => [it],
    };
  }
  final api = ref.read(apiProvider);
  return switch (it.kind) {
    ItemKind.album => api.albumTracks(it.id),
    ItemKind.playlist => api.playlistTracks(it.id),
    ItemKind.artist => api.artistTopTracks(it.id, limit: 50),
    _ => [it],
  };
}

Future<void> playItem(WidgetRef ref, Item it) async {
  final tracks = await tracksOf(ref, it);
  await ref
      .read(playerProvider.notifier)
      .playList(tracks, contextName: it.name, contextRoute: routeFor(it));
}

Future<void> toggleFavorite(
  BuildContext context,
  WidgetRef ref,
  Item it,
) async {
  final fav = !it.favorite;
  if (it.isCatalog && it.kind == ItemKind.artist) {
    // not in Jellyfin yet: the panel keeps it
    await ref.read(catalogProvider).followArtist(it, fav);
  } else {
    await ref.read(apiProvider).setFavorite(it.id, fav);
  }
  ref.read(playerProvider.notifier).updateItem(it.copyWith(favorite: fav));
  ref.invalidate(libraryProvider);
  ref.invalidate(likedTracksProvider);
  if (context.mounted) {
    final what = switch (it.kind) {
      ItemKind.track =>
        fav
            ? context.l10n.widgetActionsAddedToLiked
            : context.l10n.widgetActionsRemovedFromLiked,
      ItemKind.artist =>
        fav
            ? context.l10n.commonFollowing
            : context.l10n.widgetActionsUnfollowed,
      _ =>
        fav
            ? context.l10n.widgetActionsSavedToLibrary
            : context.l10n.widgetActionsRemovedFromLibrary,
    };
    toast(context, what);
  }
}

Future<void> _download(
  BuildContext context,
  WidgetRef ref,
  String kind,
  Item it,
) async {
  final msg = await ref.read(downloadsProvider.notifier).request(kind, it);
  if (context.mounted) toast(context, msg);
}

class _MenuEntry {
  final IconData icon;
  final String label;
  final String? shortcut;
  final Future<void> Function() action;
  const _MenuEntry(this.icon, this.label, this.action, {this.shortcut});
}

/// Right-click / "⋯" menu, with the Spotify texts.
Future<void> showItemMenu(
  BuildContext context,
  WidgetRef ref,
  Item it,
  Offset position, {
  int? queueIndex,
  String? playlistId,
}) async {
  if (it.isCatalog && it.kind == ItemKind.artist) {
    it = it.copyWith(favorite: followsCatalogArtist(ref, it));
  }
  final player = ref.read(playerProvider.notifier);
  final go = GoRouter.of(context);
  final l = context.l10n;
  // Podcast episode: only what makes sense (queue and go to the podcast).
  final entries = it.isPodcast
      ? <_MenuEntry?>[
          _MenuEntry(Icons.queue_music, l.widgetActionsAddToQueue, () async {
            player.addToQueue([it]);
            if (context.mounted) toast(context, l.widgetActionsAddedToQueue);
          }),
          _MenuEntry(Icons.playlist_play, l.widgetActionsPlayNext, () async {
            player.playNext([it]);
          }),
          if ((it.albumId ?? '').startsWith('podshow'))
            _MenuEntry(
              Icons.podcasts,
              l.widgetActionsGoToPodcast,
              () async => go.push('/podcast/${it.albumId!.substring(7)}'),
            ),
        ]
      : <_MenuEntry?>[
          _MenuEntry(
            Icons.queue_music,
            l.widgetActionsAddToQueue,
            shortcut: 'Q',
            () async {
              player.addToQueue(await tracksOf(ref, it));
              if (context.mounted) toast(context, l.widgetActionsAddedToQueue);
            },
          ),
          _MenuEntry(Icons.playlist_play, l.widgetActionsPlayNext, () async {
            player.playNext(await tracksOf(ref, it));
          }),
          if (queueIndex != null)
            _MenuEntry(
              Icons.remove_circle_outline,
              l.widgetActionsRemoveFromQueue,
              () async => player.removeAt(queueIndex),
            ),
          null,
          if (!it.isCatalog &&
              (it.kind == ItemKind.track ||
                  it.kind == ItemKind.album ||
                  it.kind == ItemKind.playlist))
            _MenuEntry(
              Icons.playlist_add,
              l.widgetActionsAddToPlaylist,
              shortcut: 'P',
              () async {
                final tracks = await tracksOf(ref, it);
                if (context.mounted) {
                  await addToPlaylistSheet(context, ref, tracks);
                }
              },
            ),
          if (playlistId != null &&
              it.kind == ItemKind.track &&
              it.playlistItemId != null)
            _MenuEntry(
              Icons.delete_outline,
              l.widgetActionsRemoveFromThisPlaylist,
              () => removeFromPlaylist(context, ref, playlistId, it),
            ),
          if (it.kind == ItemKind.playlist &&
              !it.isCatalog &&
              ref.read(hasExtrasProvider))
            _MenuEntry(
              Icons.group_add_outlined,
              l.widgetActionsInviteToEdit,
              () => inviteToEdit(context, ref, it),
            ),
          if (queueIndex != null &&
              ref.read(playerProvider).recommended.contains(it.id))
            _MenuEntry(
              Icons.auto_awesome,
              l.widgetActionsKeepInPlaylist,
              () => keepRecommendation(context, ref, it),
            ),
          // From the catalog: download to the library (requested from the extras server; shows up in the bell).
          if (it.kind == ItemKind.track && it.cloud)
            _MenuEntry(
              Icons.download_outlined,
              l.widgetActionsDownloadTrack,
              () => _download(context, ref, 'track', it),
            ),
          if ((it.kind == ItemKind.track || it.kind == ItemKind.album) &&
              isCatalogId(it.kind == ItemKind.album ? it.id : it.albumId))
            _MenuEntry(
              Icons.album_outlined,
              l.widgetActionsDownloadAlbum,
              () => _download(context, ref, 'album', it),
            ),
          if (isCatalogId(
            it.kind == ItemKind.artist ? it.id : it.mainArtist?.id,
          ))
            _MenuEntry(
              Icons.library_music_outlined,
              l.widgetActionsDownloadDiscography,
              () => _download(context, ref, 'artist', it),
            ),
          if (it.kind == ItemKind.artist && ref.read(hasExtrasProvider))
            _MenuEntry(
              Icons.checklist,
              l.widgetActionsSearchAlbums,
              () async => go.push(
                '/artist-albums?name=${Uri.encodeQueryComponent(it.name)}',
              ),
            ),
          if (it.kind == ItemKind.artist && !it.isCatalog)
            if (ref.read(qualityProvider(it.name)).value case final q?
                when q.poor > 0)
              _MenuEntry(
                Icons.high_quality_outlined,
                l.widgetActionsImproveQuality(q.poor),
                () async {
                  try {
                    await ref.read(catalogProvider).improve(q.name);
                    ref.read(downloadsProvider.notifier).refreshSoon();
                    if (context.mounted) {
                      toast(context, l.widgetActionsImprovingAlbums(q.poor));
                    }
                  } catch (e) {
                    if (context.mounted) toast(context, '$e');
                  }
                },
              ),
          if (it.kind != ItemKind.other)
            _MenuEntry(
              Icons.share_outlined,
              l.widgetActionsShare,
              () => shareItem(context, ref, it),
            ),
          // Library album still in MP3: look for FLAC (replaces the MP3 if the whole album is found).
          if (it.kind == ItemKind.album && !it.isCatalog)
            if (ref
                    .read(qualityProvider(it.mainArtist?.name ?? ''))
                    .value
                    ?.of(it.name)
                case final q? when !q.flac && !q.partial)
              _MenuEntry(
                Icons.high_quality_outlined,
                l.widgetActionsSearchFlac,
                () async {
                  try {
                    await ref
                        .read(catalogProvider)
                        .flac(it.mainArtist?.name ?? '', q.folder);
                    ref.read(downloadsProvider.notifier).refreshSoon();
                    if (context.mounted) {
                      toast(context, l.widgetActionsSearchingFlac(it.name));
                    }
                  } catch (e) {
                    if (context.mounted) toast(context, '$e');
                  }
                },
              ),
          // Store on the device to listen without internet.
          if (it.kind == ItemKind.track && !it.isCatalog)
            ref.read(offlineProvider).has(it.id)
                ? _MenuEntry(
                    Icons.arrow_circle_down,
                    l.commonRemoveFromDevice,
                    () async {
                      await ref
                          .read(offlineProvider.notifier)
                          .removeTrack(it.id);
                      if (context.mounted) {
                        toast(context, l.widgetActionsTrackRemovedFromDevice);
                      }
                    },
                  )
                : _MenuEntry(
                    Icons.arrow_circle_down_outlined,
                    l.commonDownloadToDevice,
                    () async {
                      await ref.read(offlineProvider.notifier).saveTracks([it]);
                      if (context.mounted) {
                        toast(context, l.widgetActionsDownloadingToDevice);
                      }
                    },
                  ),
          if ((it.kind == ItemKind.album || it.kind == ItemKind.playlist) &&
              !it.isCatalog)
            ref.read(offlineProvider).saved(it.id)
                ? _MenuEntry(
                    Icons.arrow_circle_down,
                    l.commonRemoveFromDevice,
                    () async {
                      await ref
                          .read(offlineProvider.notifier)
                          .removeCollection(it.id);
                      if (context.mounted) {
                        toast(context, l.widgetActionsRemovedFromDevice);
                      }
                    },
                  )
                : _MenuEntry(
                    Icons.arrow_circle_down_outlined,
                    l.commonDownloadToDevice,
                    () async {
                      final tracks = await tracksOf(ref, it);
                      await ref
                          .read(offlineProvider.notifier)
                          .saveCollection(it.id, it.name, it, tracks);
                      if (context.mounted) {
                        toast(context, l.widgetActionsDownloadingToDevice);
                      }
                    },
                  ),
          null,
          if (!it.isCatalog || it.kind == ItemKind.artist)
            _MenuEntry(
              it.favorite ? Icons.check_circle : Icons.add_circle_outline,
              switch (it.kind) {
                ItemKind.track =>
                  it.favorite ? l.commonRemoveFromLiked : l.commonAddToLiked,
                ItemKind.artist =>
                  it.favorite ? l.widgetActionsUnfollow : l.commonFollow,
                _ =>
                  it.favorite
                      ? l.widgetActionsRemoveFromLibrary
                      : l.widgetActionsAddToLibrary,
              },
              shortcut: 'L',
              () => toggleFavorite(context, ref, it),
            ),
          null,
          if (it.kind == ItemKind.track && !it.isCatalog)
            _MenuEntry(
              Icons.sensors,
              l.widgetActionsGoToSongRadio,
              shortcut: 'R',
              () async {
                final mix = await ref.read(apiProvider).instantMix(it.id);
                await player.playList([
                  it,
                  ...mix.where((t) => t.id != it.id),
                ], contextName: l.audioRadioContext(it.name));
              },
            ),
          if (it.kind != ItemKind.track && !it.isCatalog)
            _MenuEntry(Icons.sensors, l.widgetActionsStartMix, () async {
              final mix = await ref.read(apiProvider).instantMix(it.id);
              await player.playList(
                mix,
                contextName: l.widgetActionsMixOf(it.name),
              );
            }),
          if (it.mainArtist != null && it.kind != ItemKind.artist)
            _MenuEntry(
              Icons.person_outline,
              l.widgetActionsGoToArtist,
              shortcut: 'Alt+A',
              () async => go.go('/artist/${it.mainArtist!.id}'),
            ),
          if (it.kind == ItemKind.track && it.albumId != null)
            _MenuEntry(
              Icons.album_outlined,
              l.widgetActionsGoToAlbum,
              shortcut: 'A',
              () async => go.go('/album/${it.albumId}'),
            ),
          null,
          _MenuEntry(Icons.link, l.widgetActionsCopyName, () async {
            await Clipboard.setData(
              ClipboardData(
                text: it.artistLine.isEmpty
                    ? it.name
                    : '${it.name} — ${it.artistLine}',
              ),
            );
            if (context.mounted) toast(context, l.widgetActionsCopied);
          }),
        ];
  // Removes repeated separators or ones at the ends.
  final clean = <_MenuEntry?>[];
  for (final e in entries) {
    if (e == null && (clean.isEmpty || clean.last == null)) continue;
    clean.add(e);
  }
  if (clean.isNotEmpty && clean.last == null) clean.removeLast();

  if (isCompact(context)) {
    final chosen = await showModalBottomSheet<_MenuEntry>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheet).height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Cover(it, size: 48, round: it.kind == ItemKind.artist),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (it.artistLine.isNotEmpty)
                            Text(
                              it.artistLine,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Pm.subdued),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12),
              for (final e in clean)
                if (e != null)
                  ListTile(
                    leading: Icon(e.icon, color: Pm.subdued),
                    title: Text(e.label),
                    onTap: () => Navigator.of(sheet).pop(e),
                  ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) await chosen.action();
    return;
  }

  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final chosen = await showMenu<_MenuEntry>(
    context: context,
    position: RelativeRect.fromRect(
      position & const Size(1, 1),
      Offset.zero & overlay.size,
    ),
    constraints: const BoxConstraints(minWidth: 260, maxWidth: 320),
    items: [
      for (final e in clean)
        if (e == null)
          const PopupMenuDivider(height: 8)
        else
          PopupMenuItem<_MenuEntry>(
            value: e,
            height: 40,
            child: Row(
              children: [
                Icon(e.icon, size: 18, color: Pm.subdued),
                const SizedBox(width: 12),
                Expanded(child: Text(e.label)),
                if (e.shortcut != null)
                  Text(
                    e.shortcut!,
                    style: TextStyle(color: Pm.muted, fontSize: 12),
                  ),
              ],
            ),
          ),
    ],
  );
  if (chosen != null) await chosen.action();
}
