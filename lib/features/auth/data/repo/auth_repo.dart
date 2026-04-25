import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctory/features/auth/data/model/auth_response.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';

abstract class AuthRepo {
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

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepoImpl(this._dataSource);

  @override
  Future<ApiResult<AuthResponse>> signup(SignupRequest request) async {
    final result = await _dataSource.signup(request);
    return result.fold(
      onSuccess: (response) async {
        // Option to save user data directly after signup if needed
        // await UserSession.saveUser({'data': {'accessToken': response.accessToken, 'user': response.user?.toJson()}});
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> login(LoginRequest request) async {
    final result = await _dataSource.login(request);
    return result.fold(
      onSuccess: (response) async {
        await UserSession.saveUser({
          'data': {
            'accessToken': response.accessToken,
            'refreshToken': response.refreshToken,
            'user': response.user?.toJson(),
          },
        });
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<void>> verify(String email, String code) async {
    return await _dataSource.verify(email, code);
  }

  @override
  Future<ApiResult<void>> forgotPassword(String email) async {
    return await _dataSource.forgotPassword(email);
  }

  @override
  Future<ApiResult<bool>> verifyResetToken(String email, String token) async {
    return await _dataSource.verifyResetToken(email, token);
  }

  @override
  Future<ApiResult<void>> resetPassword(
    String email,
    String token,
    String newPassword,
  ) async {
    return await _dataSource.resetPassword(email, token, newPassword);
  }

  @override
  Future<ApiResult<AuthResponse>> refreshToken(String token) async {
    return await _dataSource.refreshToken(token);
  }

  @override
  Future<ApiResult<UserModel>> getProfile() async {
    return await _dataSource.getProfile();
  }

  @override
  Future<ApiResult<AuthResponse>> socialLogin({
    required String provider,
    required String accessToken,
    String? name,
    String? email,
  }) async {
    final result = await _dataSource.socialLogin(
      provider: provider,
      accessToken: accessToken,
      name: name,
      email: email,
    );
    return result.fold(
      onSuccess: (response) async {
        await UserSession.saveUser({
          'data': {
            'accessToken': response.accessToken,
            'refreshToken': response.refreshToken,
            'user': response.user?.toJson(),
          },
        });
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }
}
