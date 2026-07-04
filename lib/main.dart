import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/notifications/fcm_service.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/src/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:doctory/core/network/util/auth_listener.dart';
import 'package:doctory/core/services/remote_config_service.dart'; // Add this import

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parallelize independent initializations
  Future<void> initGoogleMaps() async {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      // Use Texture Layer Hybrid Composition for better scroll/gesture perf.
      // This avoids the old Hybrid Composition (useAndroidViewSurface)
      // which causes constant compositing overhead and map jank.
      mapsImplementation.useAndroidViewSurface = false;
      try {
        await mapsImplementation.initializeWithRenderer(
          AndroidMapRenderer.latest,
        );
      } catch (e) {
        debugPrint("Google Maps initialization: $e");
      }
    }
  }

  Future<void> initFirebase() async {
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
      // Initialize the rest of FCM (permissions, token, foreground listeners)
      // Moved to background after runApp FBMessaging.initialize();
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
    }
  }

  await Future.wait([
    initGoogleMaps(),
    initFirebase(),
    EasyLocalization.ensureInitialized(),
    AppThemeManager.instance.initialize(),
  ]);

  await ServiceLocator.init();
  setupAuthListener();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translation',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const Doctory(),
    ),
  );

  // Initialize Remote Config in the background after runApp
  RemoteConfigService.init(); // No await here to avoid blocking

  // Initialize FCM in the background after runApp
  FBMessaging.initialize();
}
