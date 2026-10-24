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
import '../../features/practice/data/practice_store.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/profile_setup_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../shared/widgets/phone_shell.dart';

/// Keeps the welcome and sign-in screens outside the tabbed app shell.
GoRouter createAppRouter(
  AuthService authService, {
  required PracticeStore practiceStore,
  required Future<void> Function(bool) onDarkModeChanged,
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
      builder: (context, state) =>
          SignInPage(signIn: authService.signIn, signUp: authService.signUp),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ListenableBuilder(
          listenable: practiceStore,
          builder: (context, _) {
            if (!practiceStore.isLoaded) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (!practiceStore.hasCompletedProfile) {
              return ProfileSetupPage(
                store: practiceStore,
                onSignOut: authService.signOut,
              );
            }
            return PhoneShell(
              body: navigationShell,
              name: practiceStore.data.displayName,
              instrument: practiceStore.data.instrument,
              syncError: practiceStore.error,
              currentIndex: navigationShell.currentIndex,
              onTabTap: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            );
          },
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => TodayPage(store: practiceStore),
            ),
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
                  builder: (context, state) =>
                      TunerMetronomePage(store: practiceStore),
                ),
                GoRoute(
                  path: 'warm-up',
                  builder: (context, state) => WarmupPage(store: practiceStore),
                ),
                GoRoute(
                  path: 'main',
                  builder: (context, state) => MainPracticePage(
                    initialSong: state.uri.queryParameters['song'],
                    store: practiceStore,
                  ),
                ),
                GoRoute(
                  path: 'cool-down',
                  builder: (context, state) =>
                      CoolDownPage(store: practiceStore),
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
              builder: (context, state) => ProgressPage(store: practiceStore),
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
                onDarkModeChanged: onDarkModeChanged,
                store: practiceStore,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
