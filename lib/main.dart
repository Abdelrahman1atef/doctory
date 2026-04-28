
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/notifications/fcm_service.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/src/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Maps Renderer for Android
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    try {
      await mapsImplementation.initializeWithRenderer(
        AndroidMapRenderer.latest,
      );
    } catch (e) {
      debugPrint("Google Maps initialization: $e");
    }
  }

  // Initialize Firebase...
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
    await FBMessaging.initialize();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  await EasyLocalization.ensureInitialized();
  await AppThemeManager.instance.initialize();
  await ServiceLocator.init();

  // Precache critical SVG icons
  await AppAssets.precacheIcons();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translation',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const Doctory(),
    ),
  );
}
