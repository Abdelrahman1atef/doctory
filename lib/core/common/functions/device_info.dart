import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String> getDeviceToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    return token ?? '';
  } catch (_) {
    return '';
  }
}

Future<String> getDeviceId() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // androidId
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  } catch (_) {
    return '';
  }
}
