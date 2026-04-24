import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? verificationCode;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    this.user,
    this.verificationCode,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Standard wrapper: json['data'] contains the actual result
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    // Check if user info is nested or flat
    UserModel? user;
    if (data['user'] != null) {
      user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } else if (data.containsKey('email') && data.containsKey('fullName')) {
      // Flat structure (AuthResponseDto)
      user = UserModel.fromJson(data);
    }

    return AuthResponse(
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'],
      verificationCode: data['verificationCode']?.toString(),
      user: user,
    );
  }
}
