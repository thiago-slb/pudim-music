import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/library.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/common.dart';
import '../../ui/widgets/downloads_bell.dart';

import 'package:go_router/go_router.dart';

import '../../state/offline.dart';
import '../../ui/widgets/mix_button.dart';
import '../recap/recap_page.dart';
import '../chat/chat_pages.dart';
import '../podcasts/podcasts.dart';
import '../../api/catalog.dart';
import '../playlist/playlist_edit.dart';

class HomeData {
  final List<Item> quick;
  final List<Item> madeForYou;
  final List<Item> recentAlbums;
  final List<Item> spotify;
  final List<Item> saved;
  final List<Item> latest;
  final List<Item> topArtists;
  final List<Item> topAlbums;
  HomeData({
    required this.quick,
    required this.madeForYou,
    required this.recentAlbums,
    required this.spotify,
    required this.saved,
    required this.latest,
    required this.topArtists,
    required this.topAlbums,
  });
}

/// Álbum "de mentira" montado a partir de uma faixa (para não buscar cada álbum).
Item albumOf(Item t) => Item(
  id: t.albumId!,
  name: t.album ?? '',
  kind: ItemKind.album,
  albumArtists: t.albumArtists,
  primaryTag: t.albumPrimaryTag,
);

List<Item> _distinctAlbums(List<Item> tracks, int max) {
  final seen = <String>{};
  final out = <Item>[];
  for (final t in tracks) {
    if (t.albumId == null || !seen.add(t.albumId!)) continue;
    out.add(albumOf(t));
    if (out.length >= max) break;
  }
  return out;
}

List<Item> _distinctArtists(List<Item> tracks, int max) {
  final seen = <String>{};
  final out = <Item>[];
  for (final t in tracks) {
    final a = t.mainArtist;
    if (a == null || a.id.isEmpty || !seen.add(a.id)) continue;
    out.add(Item(id: a.id, name: a.name, kind: ItemKind.artist));
    if (out.length >= max) break;
  }
  return out;
}

final homeProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final api = ref.watch(apiProvider);
  final lib = await ref.watch(libraryProvider.future);
  final r = await Future.wait([
    api.recentlyPlayedTracks(limit: 60),
    api.latestAlbums(limit: 20),
    api.mostPlayedTracks(limit: 200),
  ]);
  final recent = r[0];
  final most = r[2];
  final pls = lib.playlists;
  final descobertas = pls
      .where((p) => p.name.startsWith('Descobertas da semana'))
      .toList();
  final auto = pls.where((p) => p.name.endsWith('_automatic')).toList();
  final mistura = pls.where((p) => p.name == 'Mistura da semana').toList();
  // montadas pelo painel: daylist (muda com a hora), Radar (sexta) e Blends
  final daylist = pls.where((p) => p.name.startsWith('daylist · ')).toList();
  final radar = pls.where((p) => p.name == 'Radar de Novidades').toList();
  final blends = pls.where((p) => p.name.startsWith('Blend · ')).toList();

  // Atalhos do topo: o que foi aberto por último na Sua Biblioteca.
  final order = ref.read(recentOpenProvider);
  final all = [...pls, ...lib.albums, ...lib.artists];
  final byId = {for (final i in all) i.id: i};
  final quick = <Item>[
    for (final id in order)
      if (byId[id] != null) byId[id]!,
  ];
  for (final p in [...descobertas, ...pls]) {
    if (quick.length >= 8) break;
    if (!quick.any((q) => q.id == p.id)) quick.add(p);
  }

  return HomeData(
    quick: quick.take(8).toList(),
    madeForYou: [
      ...daylist,
      ...descobertas,
      ...radar,
      ...mistura,
      ...blends,
      ...auto,
    ],
    recentAlbums: _distinctAlbums(recent, 12),
    spotify: pls.where((p) => p.name.startsWith('Spotify · ')).toList(),
    saved: pls.where((p) => !isGeneratedPlaylist(p.name)).toList(),
    latest: r[1].where((i) => i.kind == ItemKind.album).toList(),
    topArtists: _distinctArtists(most, 12),
    topAlbums: _distinctAlbums(most, 12),
  );
});

String _clean(String name) => name
    .replaceFirst('Spotify · ', '')
    .replaceFirst('Deezer · ', '')
    .replaceFirst(RegExp(r'_automatic$'), '');

/// Aba escolhida na Início (0 Tudo, 1 Música, 2 Podcasts); fica ao voltar para a Início.
final homeTab = ValueNotifier<int>(0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeProvider);
    // No celular, margens laterais menores (as capas vão mais perto da borda).
    final side = isCompact(context) ? 4.0 : 12.0;
    final inner = isCompact(context) ? 6.0 : 12.0;
    final name = ref.watch(sessionProvider).value?.userName ?? '';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A2A5C), Pm.base],
          stops: [0, 0.35],
        ),
      ),
      child: data.when(
        loading: () => const LoadingBox(),
        error: (e, _) {
          // Sem internet e sem cópia da Início: mostra o que está baixado no aparelho.
          final off = ref.watch(offlineProvider);
          final heads = [
            for (final c in off.collections.values)
              if (c.head != null) c.head!,
          ];
          if (heads.isEmpty) {
            return ErrorBox(e, onRetry: () => ref.invalidate(homeProvider));
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(side, 16, side, 48),
            children: [
              Shelf(
                title: context.l10n.homeDownloadedOnDevice,
                items: heads,
                onShowAll: () => context.go('/collection/offline'),
              ),
            ],
          );
        },
        data: (d) => ListView(
          padding: EdgeInsets.fromLTRB(side, 16, side, 48),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: inner),
              child: Row(
                children: [
                  if (isCompact(context)) ...[
                    const UserAvatar(),
                    const SizedBox(width: 12),
                  ],
                  for (final (i, label) in [
                    (0, context.l10n.commonAll),
                    (1, context.l10n.homeTabMusic),
                    if (ref.watch(hasExtrasProvider))
                      (2, context.l10n.commonPodcasts),
                  ])
                    ValueListenableBuilder<int>(
                      valueListenable: homeTab,
                      builder: (_, tab, _) => Chip2(
                        label,
                        selected: tab == i,
                        onTap: () => homeTab.value = i,
                      ),
                    ),
                  if (isCompact(context)) ...[
                    const Spacer(),
                    const ChatButton(),
                    const DownloadsBell(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: homeTab,
              builder: (_, tab, _) => tab == 2
                  ? const PodcastsHome()
                  : _HomeMusic(d: d, inner: inner, name: name, all: tab == 0),
            ),
          ],
        ),
      ),
    );
  }
}

/// Prateleiras de música da Início (em "Tudo" entram também os podcasts que você segue).
class _HomeMusic extends ConsumerWidget {
  final HomeData d;
  final double inner;
  final String name;
  final bool all;
  const _HomeMusic({
    required this.d,
    required this.inner,
    required this.name,
    required this.all,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subs = all && ref.watch(hasExtrasProvider)
        ? (ref.watch(podcastSubsProvider).value ?? const <PodcastShow>[])
        : const <PodcastShow>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (d.quick.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inner),
            child: LayoutBuilder(
              builder: (_, c) {
                final cols = c.maxWidth > 900 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: cols,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: (c.maxWidth / cols) / 56,
                  children: [for (final i in d.quick) QuickTile(i)],
                );
              },
            ),
          ),
        const SizedBox(height: 28),
        Shelf(
          overline: context.l10n.homeMadeFor,
          title: name,
          items: d.madeForYou,
          subtitleOf: (p) => p.name.startsWith('Descobertas')
              ? context.l10n.homeMixDiscoveries
              : p.name == 'Mistura da semana'
              ? context.l10n.homeMixWeekly
              : p.name == 'Radar de Novidades'
              ? context.l10n.homeMixRadar
              : p.name.startsWith('daylist · ')
              ? context.l10n.homeMixDaylist
              : p.name.startsWith('Blend · ')
              ? context.l10n.homeMixBlend
              : context.l10n.homeMixAuto,
        ),
        const RecapBanner(),
        MixInvites(playlistNames: [for (final p in d.madeForYou) p.name]),
        Shelf(title: context.l10n.commonRecentlyPlayed, items: d.recentAlbums),
        _RadioShelf(artists: d.topArtists),
        Shelf(
          title: context.l10n.homeSpotifyPlaylists,
          items: d.spotify,
          subtitleOf: (p) => _clean(p.name) == p.name
              ? context.l10n.commonPlaylist
              : context.l10n.homeFromSpotify,
        ),
        Shelf(title: context.l10n.homeYourPlaylists, items: d.saved),
        Shelf(title: context.l10n.homeTopAlbums, items: d.topAlbums),
        Shelf(title: context.l10n.homeTopArtists, items: d.topArtists),
        Shelf(title: context.l10n.homeRecentlyAdded, items: d.latest),
        PodcastShelf(title: context.l10n.homeYourPodcasts, shows: subs),
      ],
    );
  }
}

/// "Rádios recomendadas": Mix instantâneo dos artistas mais ouvidos.
class _RadioShelf extends ConsumerWidget {
  final List<Item> artists;
  const _RadioShelf({required this.artists});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (artists.isEmpty) return const SizedBox.shrink();
    final compact = isCompact(context);
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 12),
            child: SectionHeader(
              context.l10n.homeRadiosTitle,
              subtitle: context.l10n.homeRadiosSubtitle,
            ),
          ),
          SizedBox(
            height: compact
                ? 154 + 62 * MediaQuery.textScalerOf(context).scale(1)
                : 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [for (final a in artists) _RadioCard(a)],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioCard extends ConsumerStatefulWidget {
  final Item artist;
  const _RadioCard(this.artist);
  @override
  ConsumerState<_RadioCard> createState() => _RadioCardState();
}

class _RadioCardState extends ConsumerState<_RadioCard> {
  bool _hover = false;
  static const _colors = [
    Color(0xFFF37B67),
    Color(0xFFF59BB6),
    Color(0xFF9CF0C3),
    Color(0xFFE8F57A),
    Color(0xFFA8A4F8),
    Color(0xFF7FC8F8),
  ];

  @override
  Widget build(BuildContext context) {
    final a = widget.artist;
    final color = _colors[a.name.hashCode.abs() % _colors.length];
    final ctxName = context.l10n.audioRadioContext(a.name);
    final q = ref.watch(playerProvider);
    final playingHere = q.contextName == ctxName && q.playing;
    final compact = isCompact(context);
    final cover = compact ? 132.0 : 156.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _play,
        child: Container(
          width: compact ? 144 : 180,
          padding: EdgeInsets.all(compact ? 6 : 12),
          decoration: BoxDecoration(
            color: _hover ? Pm.highlight : Colors.transparent,
            borderRadius: BorderRadius.circular(Pm.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: cover,
                height: cover,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 8,
                      top: 6,
                      child: Text(
                        context.l10n.homeRadioBadge,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Center(child: Cover(a, size: 92, round: true)),
                    Positioned(
                      left: 8,
                      bottom: 6,
                      right: 8,
                      child: Text(
                        a.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (_hover || playingHere)
                      Positioned(
                        right: 8,
                        bottom: 30,
                        child: GreenPlayButton(
                          size: 44,
                          playing: playingHere,
                          onPressed: _play,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.homeRadioWith(a.name),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Pm.subdued, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _play() async {
    final q = ref.read(playerProvider);
    final ctxName = context.l10n.audioRadioContext(widget.artist.name);
    if (q.contextName == ctxName) {
      await ref.read(playerProvider.notifier).togglePlay();
      return;
    }
    final mix = await ref.read(apiProvider).instantMix(widget.artist.id);
    await ref.read(playerProvider.notifier).playList(mix, contextName: ctxName);
  }
}
