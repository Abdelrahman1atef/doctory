import 'dart:convert';
import 'dart:developer';
import 'package:doctory/core/common/widgets/layout/abher_payment_webview.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../session/user_session.dart';

/// نظام إدارة إشعارات Firebase
/// Firebase Messaging Management System
class FBMessaging {
  FBMessaging._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin? _notificationsPlugin;
  static bool _isInitialized = false;

  /// Callback invoked when the FCM token is obtained or refreshed.
  /// Set from the app layer to send the token to the backend.
  static void Function(String token)? onTokenUpdated;

  // ==================== NOTIFICATION CHANNELS ====================

  /// تم تعديل القناة لتطابق المشروع النيتف
  static const _androidChannel = AndroidNotificationChannel(
    'cart_channel',
    'Cart Channel',
    description: 'receive all cart related notifications',
    importance: Importance.high,
    playSound: true,
  );

  static const _clinicChannel = AndroidNotificationChannel(
    'clinic_channel',
    'Clinic Notifications',
    description: 'receive clinic dashboard notifications',
    importance: Importance.high,
    playSound: true,
  );

  // ==================== BACKGROUND HANDLERS ====================

  /// معالج الإشعارات في الخلفية
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Background handlers run in a separate isolate, so Firebase
    // must be re-initialized here using explicit options.
    // await Firebase.initializeApp(
    //   // options: DefaultFirebaseOptions.currentPlatform,
    // );
    await _setNotificationPresentationOptions();
    log('Background message received: ${message.messageId}');
  }

  /// معالج النقر على الإشعارات
  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationHandler(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        final data = json.decode(response.payload!);
        final notification = FCMNotification.fromMap(data);
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error parsing notification payload: $e');
      }
    }
  }

  // ==================== INITIALIZATION ====================

  /// تهيئة نظام الإشعارات (Firebase.initializeApp يتعمل في الـ main قبلها)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _setupNotificationChannels();
      await _requestPermissions();
      await _configureMessagingHandlers();
      await _getToken();

      // We wrap subscribeToTopic in a try-catch because it will throw
      // if the APNs/FCM token is missing (e.g. on iOS Simulators).
      try {
        await _messaging.subscribeToTopic("all");
      } catch (e) {
        log('Error subscribing to topic "all": $e');
      }

      _isInitialized = true;
      log('Firebase Messaging initialized successfully');
    } catch (e) {
      log('Error initializing Firebase Messaging: $e');
    }
  }

  // ==================== NOTIFICATION SETUP ====================

  /// إعداد قنوات الإشعارات
  static Future<void> _setupNotificationChannels() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    await _notificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await _notificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_clinicChannel);

    const androidSettings = AndroidInitializationSettings('ic_stat_splash');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
    );

    await _notificationsPlugin?.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!);
            final notification = FCMNotification.fromMap(data);
            _handleNotificationOnClick(notification, appIsOpened: true);
          } catch (e) {
            log('Error handling notification response: $e');
          }
        }
      },
    );
  }

  /// طلب أذونات الإشعارات
  static Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _setNotificationPresentationOptions();
  }

  /// إعداد خيارات عرض الإشعارات
  static Future<void> _setNotificationPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ==================== MESSAGE HANDLERS ====================

  /// تكوين معالجات الرسائل
  static Future<void> _configureMessagingHandlers() async {
    // معالجة الرسالة الأولية عند تشغيل التطبيق
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      try {
        FCMNotification notification = FCMNotification.fromMap(initialMessage.data);
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error handling initial message: $e');
      }
    }

    // معالجة الرسائل في المقدمة
    FirebaseMessaging.onMessage.listen(
      (message) => _processMessageInForeground(message, appIsOpened: true),
    );

    // معالجة الرسائل عند فتح التطبيق من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      try {
        FCMNotification notification = FCMNotification.fromMap(message.data);
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error handling message opened app: $e');
      }
    });

    // الاستماع لتحديث رمز FCM وإرساله للخادم
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      log('FCM Token refreshed: $token');
      UserSession.fcmToken = token;
      onTokenUpdated?.call(token);
    });
  }

  /// معالجة الرسائل في المقدمة
  static Future<void> _processMessageInForeground(
    RemoteMessage message, {
    required bool appIsOpened,
    bool showNotification = true,
  }) async {
    log('Message received in foreground: ${message.messageId}');
    log('Message data: ${message.data}');

    // عرض الإشعار
    if (showNotification) {
      await _showNotification(message);
    }
  }

  /// عرض الإشعار
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    // محاولة استخراج العنوان والمحتوى من الـ data إذا كان الـ notification null
    // ده بيحصل في بعض الباكلودز اللي بتتبعت من المشروع النيتف
    final title = notification?.title ?? data['title']?.toString();
    final body = notification?.body ?? data['message']?.toString();

    if (title == null && body == null) return;

    try {
      await _notificationsPlugin?.show(
        id: message.hashCode,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'cart_channel',
            'Cart Channel',
            channelDescription: 'receive all cart related notifications',
            icon: 'ic_stat_splash',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode(data),
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  // ==================== TOKEN MANAGEMENT ====================

  /// الحصول على رمز FCM
  static Future<void> _getToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Wait a little bit for the APNs token to be configured on iOS
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          log('APNS token is null, waiting 3 seconds...');
          await Future<void>.delayed(const Duration(seconds: 3));
          apnsToken = await _messaging.getAPNSToken();
        }
        if (apnsToken == null) {
          log(
            'WARNING: APNS token is still null. If you are on an iOS Simulator, push notifications will NOT work and FCM token fetching will fail.',
          );
        } else {
          log('APNS Token: $apnsToken');
        }
      }

      final token = await _messaging.getToken();
      log('FCM Token: $token');
      UserSession.fcmToken = token ?? '';
      if (token != null && token.isNotEmpty) {
        onTokenUpdated?.call(token);
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  /// إلغاء رمز FCM
  static Future<void> revokeToken() async {
    try {
      await _messaging.deleteToken();
      UserSession.fcmToken = "";
      log('FCM token revoked');
    } catch (e) {
      log('Error revoking FCM token: $e');
    }
  }

  // ==================== TOPIC MANAGEMENT ====================

  /// الاشتراك في مواضيع العميل
  static Future<void> subscribeToClient() async {
    try {
      await _messaging.subscribeToTopic("all");
      await _messaging.subscribeToTopic("client");
      log("Subscribed to client topics");
    } catch (e) {
      log('Error subscribing to client topics: $e');
    }
  }

  /// الاشتراك في مواضيع المزود
  static Future<void> subscribeToProvider() async {
    try {
      await _messaging.subscribeToTopic("all");
      await _messaging.subscribeToTopic("provider");
      log("Subscribed to provider topics");
    } catch (e) {
      log('Error subscribing to provider topics: $e');
    }
  }

  // ==================== NOTIFICATION HANDLING ====================

  /// معالجة النقر على الإشعار
  static void _handleNotificationOnClick(FCMNotification notification, {bool appIsOpened = false}) {
    log('Notification clicked: ${notification.type}');
    log('Notification related data: ${notification.relatedData}');

    // If notification carries a deep link, dispatch through DeepLinkService
    if (notification.link != null && notification.link!.isNotEmpty) {
      final uri = Uri.tryParse(notification.link!);
      if (uri != null) {
        DeepLinkService.instance.dispatch(uri);
        return;
      }
    }

    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) return;

    // التنقل بناءً على النوع المسجل في المشروع النيتف
    switch (notification.type) {
      case "AppointmentConfirmation":
      case "AppointmentAccepted":
        if (notification.appointmentId != null) {
          AppRouter.router.go(
            '/my-appointments/details?id=${notification.appointmentId}',
          );
          return;
        }
        if (notification.paymentUrl != null &&
            notification.paymentUrl!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AbherPaymentWebView(
                url: notification.paymentUrl!,
                onPaymentResult: (_) {},
              ),
            ),
          );
          return;
        }
        break;
      case "NewMessage":
        if (notification.conversationId != null) {
          AppRouter.router.pushNamed(
            'chatRoom',
            pathParameters: {'id': notification.conversationId!},
          );
        }
        break;
      default:
        AppRouter.router.push('/');
    }
  }
}

// ==================== NOTIFICATION MODEL ====================

/// نموذج إشعار FCM
/// FCM Notification Model
class FCMNotification {
  final String? title;
  final String? message;
  final String? type;
  final String? relatedData;
  final String? conversationId;
  final String? appointmentId;
  final String? paymentUrl;
  final String? link;

  FCMNotification({this.title, this.message, this.type, this.relatedData, this.conversationId, this.appointmentId, this.paymentUrl, this.link});

  /// إنشاء من Map مطابق للنيتف (related_data - title - message)
  factory FCMNotification.fromMap(Map<String, dynamic> map) {
    return FCMNotification(
      title: map["title"]?.toString(),
      message: map["message"]?.toString() ?? map["body"]?.toString(),
      type: map["type"]?.toString(),
      conversationId: map["conversationId"]?.toString(),
      appointmentId: map["appointmentId"]?.toString(),
      paymentUrl: map["paymentUrl"]?.toString(),
      relatedData: map["related_data"]?.toString(),
      link: map["link"]?.toString(),
    );
  }

  /// تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "message": message,
      "type": type,
      "conversationId": conversationId,
      "appointmentId": appointmentId,
      "paymentUrl": paymentUrl,
      "related_data": relatedData,
      "link": link,
    };
  }

  @override
  String toString() {
    return 'FCMNotification(title: $title, message: $message, type: $type, link: $link, relatedData: $relatedData)';
  }
}
