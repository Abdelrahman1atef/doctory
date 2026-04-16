import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/features/intro/router/intro_router.dart';
import 'package:doctory/features/auth/router/auth_router.dart';

import 'package:doctory/core/session/user_session.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = AppRoutes.splash;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialRoute,
    refreshListenable: UserSession.userNotifier,
    debugLogDiagnostics: true,
    observers: [BotToastNavigatorObserver(), FlutterSmartDialog.observer],
    redirect: (context, state) async {
      // Minimal redirect logic for now
      return null;
    },

    routes: [...IntroRouter.routes, ...AuthRouter.routes],

    // Error page
    errorPageBuilder: (context, state) {
      final ThemeData theme = Theme.of(context);
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(title: Text('error'.tr())),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                16.ph,
                Text(
                  'page_not_found'.tr(),
                  style: theme.textTheme.headlineSmall,
                ),
                8.ph,
                Text(state.uri.toString(), style: theme.textTheme.bodySmall),
                24.ph,
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.splash),
                  child: Text('back_to_home'.tr()),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
