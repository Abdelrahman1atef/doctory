import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/auth/data/data_source/auth_endpoints.dart';
import 'package:doctory/features/auth/data/model/auth_response.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<AuthResponse>> signup(SignupRequest request);
  Future<ApiResult<AuthResponse>> login(LoginRequest request);
  Future<ApiResult<void>> verify(String email, String code);
  Future<ApiResult<void>> forgotPassword(String email);
  Future<ApiResult<bool>> verifyResetToken(String email, String token);
  Future<ApiResult<void>> resetPassword(
    String email,
    String token,
    String newPassword,
  );
  Future<ApiResult<AuthResponse>> refreshToken(String token);
  Future<ApiResult<UserModel>> getProfile();
  Future<ApiResult<AuthResponse>> socialLogin({
    required String provider,
    required String accessToken,
    String? name,
    String? email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<AuthResponse>> signup(SignupRequest request) async {
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
  Future<ApiResult<void>> verify(String email, String code) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.verify,
      body: {'email': email, 'code': code},
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
      parser: (json) => json['data'] as bool,
    );
  }

  @override
  Future<ApiResult<void>> resetPassword(
    String email,
    String token,
    String newPassword,
  ) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.resetPassword,
      body: {'email': email, 'token': token, 'newPassword': newPassword},
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
  Future<ApiResult<AuthResponse>> socialLogin({
    required String provider,
    required String accessToken,
    String? name,
    String? email,
  }) async {
    return await _apiConsumer.post(
      path: AuthEndpoints.socialLogin,
      body: {
        'provider': provider,
        'accessToken': accessToken,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      },
      parser: (json) => AuthResponse.fromJson(json),
    );
  }
}
