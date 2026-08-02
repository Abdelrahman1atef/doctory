import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/alerts.dart';
import '../../router/app_router.dart';
import '../../router/router_names.dart';
import '../../locator/service_locator.dart';
import '../../session/user_session.dart';
import '../interceptors/auth_interceptor.dart';

/// Sets up a listener for unauthorized (401) events from the AuthInterceptor.
/// This should be called in the `main` function or the root widget's `initState`.
void setupAuthListener() {
  sl<AuthInterceptor>().onUnauthorized.listen((_) async {
    // Already logged out: ignore 401s fired by logout cleanup (realtime/disconnect etc.)
    if (UserSession.token.isEmpty) return;

    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      // Clear user session
      await UserSession.logout();

      // Show message
      Alerts.snack(
        text: 'session_expired_login_again'.tr(),
        state: SnackState.failed,
      );

      // Navigate to login and clear navigation stack
      context.go(AppRoutes.login);
    }
  });
}
