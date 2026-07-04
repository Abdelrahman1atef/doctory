import 'package:dio/dio.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/auth/data/data_source/auth_endpoints.dart';
import 'package:doctory/features/auth/data/model/auth_response.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';
import 'package:doctory/features/auth/data/model/update_profile_request.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<AuthResponse>> signup(
    SignupRequest request, {
    String? certificateImagePath,
    String? syndicateIdImagePath,
  });
  Future<ApiResult<AuthResponse>> login(LoginRequest request);
  Future<ApiResult<AuthResponse>> verify(String email, String code);
  Future<ApiResult<void>> forgotPassword(String email);
  Future<ApiResult<bool>> verifyResetToken(String email, String token);
  Future<ApiResult<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
  Future<ApiResult<AuthResponse>> refreshToken(String token);
  Future<ApiResult<UserModel>> getProfile();
  Future<ApiResult<bool>> updateProfile(UpdateProfileRequest request);
  Future<ApiResult<bool>> updateLanguage(int language);
  Future<ApiResult<AuthResponse>> loginFacebook(String accessToken);
  Future<ApiResult<AuthResponse>> completeFacebookRegistration({
    required String accessToken,
    required String email,
  });
  Future<ApiResult<AuthResponse>> loginGoogle(String idToken);
  Future<ApiResult<void>> logout(String refreshToken);
  Future<ApiResult<void>> deleteAccount(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<AuthResponse>> signup(
    SignupRequest request, {
    String? certificateImagePath,
    String? syndicateIdImagePath,
  }) async {
    final hasFiles =
        certificateImagePath != null || syndicateIdImagePath != null;
    if (hasFiles) {
      final body = Map<String, dynamic>.from(request.toJson());
      if (certificateImagePath != null) {
        body['certificate_image'] =
            await MultipartFile.fromFile(certificateImagePath);
      }
      if (syndicateIdImagePath != null) {
        body['syndicate_id_image'] =
            await MultipartFile.fromFile(syndicateIdImagePath);
      }
      return await _apiConsumer.post(
        path: AuthEndpoints.signup,
        body: body,
        isFormData: true,
        parser: (json) => AuthResponse.fromJson(json),
      );
    }
    return await _apiConsumer.post(
      path: AuthEndpoints.signup,
      body: request.toJson(),
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> login(LoginRequest request) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.login,
      body: request.toJson(),
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> verify(String email, String code) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.verify,
      body: {'email': email, 'code': code},
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<void>> forgotPassword(String email) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.forgetPassword,
      body: {'email': email},
    );
  }

  @override
  Future<ApiResult<bool>> verifyResetToken(String email, String token) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.verifyResetToken,
      body: {'email': email, 'token': token},
      parser: (json) => json['data'] is bool ? json['data'] : true,
    );
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.resetPassword,
      body: {
        'email': email,
        'token': token,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }

  @override
  Future<ApiResult<AuthResponse>> refreshToken(String token) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.refreshToken,
      body: {'refreshToken': token},
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<UserModel>> getProfile() async {
    return await _apiConsumer.get(
      path: AuthEndpoints.profile,
      parser: (json) => UserModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  Future<ApiResult<bool>> updateProfile(UpdateProfileRequest request) async {
    return await _apiConsumer.patch(
      path: AuthEndpoints.updateProfile,
      body: request.toJson(),
      parser: (json) => json['success'] ?? true,
    );
  }

  @override
  Future<ApiResult<bool>> updateLanguage(int language) async {
    return await _apiConsumer.put(
      path: AuthEndpoints.updateLanguage,
      body: {'language': language},
      parser: (json) => json['success'] ?? true,
    );
  }

  @override
  Future<ApiResult<AuthResponse>> loginFacebook(String accessToken) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.loginFacebook,
      body: {'accessToken': accessToken},
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> completeFacebookRegistration({
    required String accessToken,
    required String email,
  }) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.completeFacebookRegistration,
      body: {'accessToken': accessToken, 'email': email},
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> loginGoogle(String idToken) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.loginGoogle,
      body: {'idToken': idToken},
      parser: (json) => AuthResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<void>> logout(String refreshToken) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.logout,
      body: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<ApiResult<void>> deleteAccount(String userId) async {
    return await _apiConsumer.delete(
      path: '${AuthEndpoints.users}/$userId',
    );
  }
}
