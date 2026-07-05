import 'package:doctory/core/enums/device_platform.dart';

class SignupRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String? birthDate;
  final int? gender;
  final String? role;
  final String? fcmToken;
  final DevicePlatform? devicePlatform;
  final String? certificateImagePath;
  final String? syndicateIdImagePath;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    this.birthDate,
    this.gender,
    this.role,
    this.fcmToken,
    this.devicePlatform,
    this.certificateImagePath,
    this.syndicateIdImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber,
      if (birthDate != null) 'birthDate': birthDate,
      if (gender != null) 'gender': gender,
      if (role != null) 'role': role,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (devicePlatform != null) 'devicePlatform': devicePlatform!.toJson(),
    };
  }
}
