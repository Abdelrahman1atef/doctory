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
  final String? doctorType;
  final String? fcmToken;
  final DevicePlatform? devicePlatform;
  final String? professionalPracticeCardImagePath;
  final String? syndicateIdImagePath;
  final String? commercialRegisterImagePath;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    this.birthDate,
    this.gender,
    this.role,
    this.doctorType,
    this.fcmToken,
    this.devicePlatform,
    this.professionalPracticeCardImagePath,
    this.syndicateIdImagePath,
    this.commercialRegisterImagePath,
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
      if (doctorType != null) 'doctorType': doctorType,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (devicePlatform != null) 'devicePlatform': devicePlatform!.toJson(),
    };
  }
}
