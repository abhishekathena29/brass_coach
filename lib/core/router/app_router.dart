import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/auth_service.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/practice/presentation/pages/practice_hub_page.dart';
import '../../features/practice/presentation/pages/main_practice_page.dart';
import '../../features/practice/presentation/pages/warmup_page.dart';
import '../../features/practice/presentation/pages/cool_down_page.dart';
import '../../features/practice/presentation/pages/tuner_metronome_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../shared/widgets/phone_shell.dart';

/// Keeps the welcome and sign-in screens outside the tabbed app shell.
GoRouter createAppRouter(
  AuthService authService, {
  required bool Function() darkMode,
  required ValueChanged<bool> onDarkModeChanged,
}) => GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: authService.isSignedIn ? '/' : '/welcome',
  refreshListenable: authService,
  redirect: (context, state) {
    final authRoute =
        state.matchedLocation == '/welcome' ||
        state.matchedLocation == '/sign-in';
    if (!authService.isSignedIn && !authRoute) return '/welcome';
    if (authService.isSignedIn && authRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => SignInPage(signIn: authService.signIn),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return PhoneShell(
          body: navigationShell,
          email: authService.email,
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
            GoRoute(
              path: '/practice',
              builder: (context, state) => const PracticeHubPage(),
              routes: [
                GoRoute(
                  path: 'tuner',
                  builder: (context, state) => const TunerMetronomePage(),
                ),
                GoRoute(
                  path: 'warm-up',
                  builder: (context, state) => const WarmupPage(),
                ),
                GoRoute(
                  path: 'main',
                  builder: (context, state) => MainPracticePage(
                    initialSong: state.uri.queryParameters['song'],
                  ),
                ),
                GoRoute(
                  path: 'cool-down',
                  builder: (context, state) => const CoolDownPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(
                email: authService.email,
                onSignOut: authService.signOut,
                darkMode: darkMode(),
                onDarkModeChanged: onDarkModeChanged,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
