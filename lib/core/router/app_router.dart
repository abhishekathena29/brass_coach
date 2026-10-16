import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/library/presentation/pages/library_page.dart';
import '../../features/practice/presentation/pages/practice_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../shared/widgets/phone_shell.dart';

/// Route paths mirror `src/routes/*.tsx` 1:1 (`/`, `/practice`, `/library`,
/// `/progress`, `/profile`), and [StatefulShellRoute.indexedStack] plays the
/// same role as the root layout + `<Outlet />` in `src/routes/__root.tsx`:
/// one persistent shell (status bar + bottom nav) around swappable tabs,
/// each tab keeping its own state alive when you switch away and back.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return PhoneShell(
          body: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTabTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const TodayPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/practice', builder: (context, state) => const PracticePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/library', builder: (context, state) => const LibraryPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/progress', builder: (context, state) => const ProgressPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
          ],
        ),
      ],
    ),
  ],
);
