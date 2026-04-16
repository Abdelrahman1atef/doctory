import '../../../core/common/widgets/sheets/require_auth_bottom_sheet.dart';
import '../../../core/services/alerts.dart';
import '../../router/app_router.dart';
import '../../locator/service_locator.dart';
import '../interceptors/auth_interceptor.dart';

/// Sets up a listener for unauthorized (401) events from the AuthInterceptor.
/// This should be called in the `main` function or the root widget's `initState`.
void setupAuthListener() {
  sl<AuthInterceptor>().onUnauthorized.listen((_) async {
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      // Check if we are already showing the sheet to avoid stacking
      // Note: AuthInterceptor doesn't track this state anymore effectively if we use a stream,
      await Future<void>.delayed(const Duration(seconds: 1));
      // might handle it or we can add a flag here.
      // For now, we rely on the context being valid.
      Alerts.bottomSheet<void>(context, child: const RequireAuthBottomSheet());
    }
  });
}
