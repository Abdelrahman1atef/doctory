import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/src/app.dart';
import 'package:doctory/core/services/notifications/fcm_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Note: ensure you have a valid firebase_options.dart or mock it)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
