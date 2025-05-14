// lib/core/route/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../component/auth/password_reset/password_reset_screen.dart';
import '../../component/auth/sign_in/sign_in_screen.dart';
import '../../component/auth/sign_up/sign_up_screen.dart';
import '../../component/follow/follow_screen.dart';
import '../../component/follow_request/follow_request_screen.dart';
import '../../component/main/main_screen.dart';
import '../../component/password_change/password_changed_screen.dart';
import '../../component/profile_edit/profile_edit_screen.dart';
import '../../component/navigation/navigation_widget.dart';
import '../../component/setting/setting_screen.dart';
import '../../component/splash/splash_screen.dart';
import '../../component/terms/terms_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) {
        return SignInScreen();
      },
      routes: [
        GoRoute(
          path: Routes.signUp,
          builder: (context, state) {
            return SignUpScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.password,
      builder: (context, state) {
        return PasswordResetScreen();
      },
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return NavigationWidget(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.main,
              builder: (context, state) {
                return MainScreen();
              },
              routes: [
                GoRoute(
                  path: Routes.follow,
                  builder: (context, state) {
                    return FollowScreen();
                  },
                ),
                GoRoute(
                  path: Routes.followRequest,
                  builder: (context, state) {
                    return FollowRequestScreen();
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) {
                return SettingScreen();
              },
              routes: [
                GoRoute(
                  path: Routes.profileEdit,
                  builder: (context, state) {
                    return ProfileEditScreen();
                  },
                ),
                GoRoute(
                  path: Routes.passwordChange,
                  builder: (context, state) {
                    return PasswordChangeScreen();
                  },
                ),
                GoRoute(
                  path: Routes.terms,
                  builder: (context, state) {
                    return TermsScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
