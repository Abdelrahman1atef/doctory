import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? verificationCode;
  final String? clinicStatus;
  final String? verificationStatus;
  final bool isClinicSetupComplete;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    this.user,
    this.verificationCode,
    this.clinicStatus,
    this.verificationStatus,
    this.isClinicSetupComplete = false,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    UserModel? user;
    if (data['user'] != null) {
      user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } else if (data.containsKey('email') && data.containsKey('fullName')) {
      user = UserModel.fromJson(data);
    }

    return AuthResponse(
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'],
      verificationCode: data['verificationCode']?.toString(),
      user: user,
      clinicStatus: data['clinicStatus']?.toString(),
      verificationStatus: data['verificationStatus']?.toString(),
      isClinicSetupComplete: data['isClinicSetupComplete'] == true,
    );
  }
}
