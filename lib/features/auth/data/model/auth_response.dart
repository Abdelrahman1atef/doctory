import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? verificationCode;
  final String? clinicStatus;
  final String? verificationStatus;
  final bool isClinicSetupComplete;
  final String? doctorId;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    this.user,
    this.verificationCode,
    this.clinicStatus,
    this.verificationStatus,
    this.isClinicSetupComplete = false,
    this.doctorId,
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

    final clinicStatusRaw = data['clinicStatus'];
    final verificationStatusRaw = data['verificationStatus'];

    return AuthResponse(
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'],
      verificationCode: data['verificationCode']?.toString(),
      user: user,
      clinicStatus: clinicStatusRaw is int
          ? _clinicStatusFromInt(clinicStatusRaw)
          : clinicStatusRaw?.toString(),
      verificationStatus: verificationStatusRaw is int
          ? _verificationStatusFromInt(verificationStatusRaw)
          : verificationStatusRaw?.toString(),
      isClinicSetupComplete: data['isClinicSetupComplete'] == true,
      doctorId: data['doctorId']?.toString(),
    );
  }

  static String? _clinicStatusFromInt(int value) {
    switch (value) {
      case 0: return 'PendingApproval';
      case 1: return 'Active';
      case 2: return 'Suspended';
      default: return null;
    }
  }

  static String? _verificationStatusFromInt(int value) {
    switch (value) {
      case 0: return 'Pending';
      case 1: return 'Approved';
      case 2: return 'Rejected';
      default: return null;
    }
  }
  }

