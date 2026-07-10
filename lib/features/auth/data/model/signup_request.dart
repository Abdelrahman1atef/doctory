import 'package:doctory/core/common/models/type_of_user_for_register_flow.dart';
import 'package:doctory/core/enums/device_platform.dart';

class SignupRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String? birthDate;
  final int? gender;
  final TypeOfUserForRegisterFlow typeOfUser;
  final String? fcmToken;
  final DevicePlatform? devicePlatform;
  final String? doctorImagePath;
  final String? professionalPracticeCardImagePath;
  final String? unionIdImagePath;
  final String? taxCardImagePath;
  final String? commercialRegisterImagePath;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.typeOfUser,
    this.birthDate,
    this.gender,
    this.fcmToken,
    this.devicePlatform,
    this.doctorImagePath,
    this.professionalPracticeCardImagePath,
    this.unionIdImagePath,
    this.taxCardImagePath,
    this.commercialRegisterImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber,
      'typeOfUser': typeOfUser.value,
      if (birthDate != null) 'birthDate': birthDate,
      if (gender != null) 'gender': gender,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (devicePlatform != null) 'devicePlatform': devicePlatform!.toJson(),
    };
  }
}
