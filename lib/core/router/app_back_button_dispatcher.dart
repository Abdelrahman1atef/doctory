import 'package:doctory/core/router/router_names.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// System back-button policy for root screens that live outside the home
/// shell (clinic dashboard, admin, ...).
///
/// When the router has nothing left to pop, the default behaviour is to close
/// the app. Instead we go home, where the shell's own `PopScope` applies the
/// "go to home tab, then press back twice to exit" rule.
class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  AppBackButtonDispatcher({required GoRouter Function() router}) : _router = router;

  /// Resolved lazily — the router is constructed after this dispatcher.
  final GoRouter Function() _router;

  @override
  Future<bool> didPopRoute() async {
    if (await super.didPopRoute()) return true;

    final router = _router();
    if (router.state.uri.path == AppRoutes.home) return false;
    router.go(AppRoutes.home);
    return true;
  }
}
