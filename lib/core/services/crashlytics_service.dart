import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Crashlytics wrapper.
/// Every call is defensive: the app must never crash because Crashlytics
/// failed to initialize or report.
class CrashlyticsService {
  static FirebaseCrashlytics? _crashlytics;

  static Future<void> initialize() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);
    } catch (_) {
      _crashlytics = null;
    }
  }

  static void recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) {
    try {
      _crashlytics?.recordError(error, stackTrace, fatal: fatal);
    } catch (_) {}
  }

  static void recordFlutterFatalError(FlutterErrorDetails details) {
    try {
      _crashlytics?.recordFlutterFatalError(details);
    } catch (_) {}
  }

  static void log(String message) {
    try {
      _crashlytics?.log(message);
    } catch (_) {}
  }

  static Future<void> setUserIdentifier(String userId) async {
    try {
      await _crashlytics?.setUserIdentifier(userId);
    } catch (_) {}
  }

  static Future<void> setCustomKey(String key, String value) async {
    try {
      await _crashlytics?.setCustomKey(key, value);
    } catch (_) {}
  }
}
