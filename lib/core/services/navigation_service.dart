import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/router/app_router.dart';

/// NavigationService is a global wrapper around GoRouter.
/// It uses the singleton instance of GoRouter defined in AppRouter.
class NavigationService {
  static GoRouter get route => AppRouter.router;

  static BuildContext get context =>
      AppRouter.navigatorKey.currentState!.context;

  /// Navigate to a new route by path (e.g., AppRoutes.login)
  static void go(String path, {Object? extra}) {
    route.go(path, extra: extra);
  }

  /// Push a new route by path (e.g., AppRoutes.login)
  static Future<T?> push<T>(String path, {Object? extra}) async {
    return route.push<T>(path, extra: extra);
  }

  /// Navigate to a named route (ensure your routes have 'name' defined)
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    route.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a named route (ensure your routes have 'name' defined)
  static Future<T?> pushNamed<T>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return route.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pop the current route
  static void pop<T>([T? result]) {
    if (route.canPop()) {
      route.pop(result);
    }
  }

  /// Get the current path location
  static String currentRoute() {
    return route.routerDelegate.currentConfiguration.uri.toString();
  }

  /// Check if the current route matches a specific path
  static bool isRouteContain(String path) {
    return currentRoute() == path;
  }
}
