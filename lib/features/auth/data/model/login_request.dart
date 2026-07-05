import 'package:doctory/core/enums/device_platform.dart';

class LoginRequest {
  final String email;
  final String password;
  final String? fcmToken;
  final DevicePlatform? devicePlatform;

  LoginRequest({
    required this.email,
    required this.password,
    this.fcmToken,
    this.devicePlatform,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (devicePlatform != null) 'devicePlatform': devicePlatform!.toJson(),
    };
  }
}
