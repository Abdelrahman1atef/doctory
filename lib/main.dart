import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:doctory/core/services/notifications/fcm_service.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/src/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:doctory/core/network/util/auth_listener.dart';
import 'package:doctory/core/services/remote_config_service.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences early so AppThemeManager & others reuse it
  await CacheHelper.init();

  await Future.wait([
    _initFirebase(),
    EasyLocalization.ensureInitialized(),
    AppThemeManager.instance.initialize(),
  ]);

  await ServiceLocator.init();
  setupAuthListener();

  FBMessaging.onTokenUpdated = (token) async {
    if (UserSession.token.isNotEmpty) {
      try {
        sl<AuthRepo>();
      } catch (_) {}
    }
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translation',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const Doctory(),
    ),
  );

  // Defer non-essential startup work to after the first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FirebaseAnalytics.instance.logAppOpen();
    RemoteConfigService.init();
    FBMessaging.initialize();
    DeepLinkService.instance.init();

    if (kDebugMode) {
      _registerDebugDeepLinkHandlers();
    }
  });
}

void _registerDebugDeepLinkHandlers() {
  // Debug-only: handles doctory:// scheme for testing without a real domain
  // Reconstructs as https://{host}{path}?params so real handlers process it
  DeepLinkService.instance.register((uri) {
    if (uri.scheme != 'doctory') return false;
    final httpsUri = Uri(
      scheme: DeepLinkConfig.scheme,
      host: DeepLinkConfig.host,
      path: '/${uri.host}${uri.path == '/' ? '' : uri.path}',
      queryParameters: uri.queryParametersAll,
    );
    DeepLinkService.instance.dispatch(httpsUri);
    return true;
  });
}

Future<void> _initFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        if (e.toString().contains('duplicate-app')) {
          await Firebase.initializeApp();
        } else {
          rethrow;
        }
      }
    }

    FirebaseMessaging.onBackgroundMessage(
      FBMessaging.firebaseMessagingBackgroundHandler,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
}
