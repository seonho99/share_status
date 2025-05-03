import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../component/auth/password_reset_screen.dart';
import '../../component/auth/sign_in_screen.dart';
import '../../component/auth/sign_up_screen.dart';
import '../../component/follow/follow_screen.dart';
import '../../component/main/main_screen.dart';
import '../../component/widget/navigation_widget.dart';
import '../../component/setting/setting_screen.dart';
import '../../component/splash/splash_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) {
        return SignInScreen();
      },
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) {
        return SignUpScreen();
      },
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
                  path: Routes.set,
                  builder: (context, state) {
                    return SettingScreen();
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
