import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api/models.dart';
import 'features/catalog/catalog_pages.dart';
import 'features/album/album_page.dart';
import 'features/artist/artist_page.dart';
import 'features/home/home_page.dart';
import 'features/login/login_page.dart';
import 'features/lyrics/lyrics_page.dart';
import 'features/catalog/album_picker_page.dart';
import 'features/playlist/playlist_page.dart';
import 'features/recap/recap_page.dart';
import 'features/search/search_page.dart';
import 'features/settings/settings_page.dart';
import 'state/session.dart';
import 'ui/mobile/mobile_shell.dart';
import 'ui/mobile/now_playing_page.dart';
import 'ui/responsive.dart';
import 'ui/shell/app_shell.dart';
import 'ui/shell/library_sidebar.dart';
import 'features/chat/chat_pages.dart';
import 'features/profile/profile_page.dart';
import 'features/shows/shows_page.dart';
import 'features/podcasts/podcasts.dart';

/// Notifies go_router when the session changes (sign in/out).
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable(ref);
  ref.onDispose(listenable.dispose);

  Page<void> page(Widget child, GoRouterState s) =>
      NoTransitionPage(key: s.pageKey, child: child);

  // Phone screens that slide up over everything (Now Playing, lyrics, queue).
  Page<void> sheet(Widget child, GoRouterState s) => CustomTransitionPage(
    key: s.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (_, a, _, c) => SlideTransition(
      position: Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(a),
      child: c,
    ),
  );

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final s = ref.read(sessionProvider);
      if (s.isLoading) return null;
      final loggedIn = s.value != null;
      final atLogin = state.matchedLocation == '/login';
      if (!loggedIn && !atLogin) return '/login';
      if (loggedIn && atLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(
        path: '/playing',
        pageBuilder: (_, s) => sheet(const NowPlayingPage(), s),
      ),
      GoRoute(
        path: '/lyrics-full',
        pageBuilder: (_, s) => sheet(const LyricsFullPage(), s),
      ),
      GoRoute(
        path: '/queue',
        pageBuilder: (_, s) => sheet(const QueuePage(), s),
      ),
      ShellRoute(
        builder: (context, _, child) => isCompact(context)
            ? MobileShell(child: child)
            : AppShell(child: child),
        routes: [
          GoRoute(path: '/', pageBuilder: (_, s) => page(const HomePage(), s)),
          GoRoute(
            path: '/search',
            pageBuilder: (_, s) =>
                page(SearchPage(query: s.uri.queryParameters['q'] ?? ''), s),
          ),
          GoRoute(
            path: '/album/:id',
            pageBuilder: (_, s) {
              final id = s.pathParameters['id']!;
              return page(
                isCatalogId(id) ? CatalogListPage(id) : AlbumPage(id),
                s,
              );
            },
          ),
          GoRoute(
            path: '/playlist/:id',
            pageBuilder: (_, s) {
              final id = s.pathParameters['id']!;
              return page(
                isCatalogId(id) ? CatalogListPage(id) : PlaylistPage(id),
                s,
              );
            },
          ),
          GoRoute(
            path: '/artist/:id',
            pageBuilder: (_, s) {
              final id = s.pathParameters['id']!;
              return page(
                isCatalogId(id) ? CatalogArtistPage(id) : ArtistPage(id),
                s,
              );
            },
          ),
          GoRoute(
            path: '/collection/tracks',
            pageBuilder: (_, s) => page(const LikedPage(), s),
          ),
          GoRoute(
            path: '/shows',
            pageBuilder: (_, s) => page(const ShowsPage(), s),
          ),
          GoRoute(
            path: '/podcast/:id',
            pageBuilder: (_, s) =>
                page(PodcastPageView(s.pathParameters['id']!), s),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (_, s) => page(const ChatsPage(), s),
          ),
          GoRoute(
            path: '/chat/:uid',
            pageBuilder: (_, s) =>
                page(ChatThreadPage(s.pathParameters['uid']!), s),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, s) => page(const ProfilePage(), s),
          ),
          GoRoute(
            path: '/artist-albums',
            pageBuilder: (_, s) => page(
              AlbumPickerPage(artist: s.uri.queryParameters['name'] ?? ''),
              s,
            ),
          ),
          GoRoute(
            path: '/recap',
            pageBuilder: (_, s) => page(const RecapPage(), s),
          ),
          GoRoute(
            path: '/collection/offline',
            pageBuilder: (_, s) => page(const OfflinePage(), s),
          ),
          GoRoute(
            path: '/lyrics',
            pageBuilder: (_, s) => page(const LyricsPage(), s),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (_, s) => page(const LibrarySidebar(), s),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (_, s) => page(const SettingsPage(), s),
          ),
        ],
      ),
    ],
  );
});
