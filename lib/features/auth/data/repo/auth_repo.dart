import 'package:doctory/core/enums/device_platform.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctory/features/auth/data/model/auth_response.dart';
import 'package:doctory/features/auth/data/model/clinic_setup_request.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';
import 'package:doctory/features/auth/data/model/update_profile_request.dart';

abstract class AuthRepo {
  Future<ApiResult<AuthResponse>> signup(
    SignupRequest request, {
    String? doctorImagePath,
    String? professionalPracticeCardImagePath,
    String? unionIdImagePath,
    String? taxCardImagePath,
    String? commercialRegisterImagePath,
  });
  Future<ApiResult<AuthResponse>> login(LoginRequest request);
  Future<ApiResult<bool>> registerClinic(ClinicSetupRequest request);
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
  Future<ApiResult<void>> updateDeviceToken({
    required String fcmToken,
    required DevicePlatform devicePlatform,
  });
}

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepoImpl(this._dataSource);

  @override
  Future<ApiResult<AuthResponse>> signup(
    SignupRequest request, {
    String? doctorImagePath,
    String? professionalPracticeCardImagePath,
    String? unionIdImagePath,
    String? taxCardImagePath,
    String? commercialRegisterImagePath,
  }) async {
    final result = await _dataSource.signup(
      request,
      doctorImagePath: doctorImagePath,
      professionalPracticeCardImagePath: professionalPracticeCardImagePath,
      unionIdImagePath: unionIdImagePath,
      taxCardImagePath: taxCardImagePath,
      commercialRegisterImagePath: commercialRegisterImagePath,
    );
    return result.fold(
      onSuccess: (response) async {
        await _saveAuthSession(response);
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
        await _saveAuthSession(response);
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<bool>> registerClinic(ClinicSetupRequest request) async {
    return await _dataSource.registerClinic(request);
  }

  @override
  Future<ApiResult<AuthResponse>> verify(String email, String code) async {
    final result = await _dataSource.verify(email, code);
    return result.fold(
      onSuccess: (response) async {
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
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
  Future<ApiResult<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _dataSource.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
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
  Future<ApiResult<bool>> updateProfile(UpdateProfileRequest request) async {
    return await _dataSource.updateProfile(request);
  }

  @override
  Future<ApiResult<bool>> updateLanguage(int language) async {
    return await _dataSource.updateLanguage(language);
  }

  @override
  Future<ApiResult<AuthResponse>> loginFacebook(String accessToken) async {
    final result = await _dataSource.loginFacebook(accessToken);
    return result.fold(
      onSuccess: (response) async {
        if (response.accessToken.isNotEmpty) {
          await _saveAuthSession(response);
        }
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> completeFacebookRegistration({
    required String accessToken,
    required String email,
  }) async {
    final result = await _dataSource.completeFacebookRegistration(
      accessToken: accessToken,
      email: email,
    );
    return result.fold(
      onSuccess: (response) async {
        if (response.accessToken.isNotEmpty) {
          await _saveAuthSession(response);
        }
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> loginGoogle(String idToken) async {
    final result = await _dataSource.loginGoogle(idToken);
    return result.fold(
      onSuccess: (response) async {
        if (response.accessToken.isNotEmpty) {
          await _saveAuthSession(response);
        }
        return ApiResult.success(response);
      },
      onFailure: (failure) => ApiResult.failure(failure),
    );
  }

  @override
  Future<ApiResult<void>> logout(String refreshToken) async {
    return await _dataSource.logout(refreshToken);
  }

  @override
  Future<ApiResult<void>> deleteAccount(String userId) async {
    return await _dataSource.deleteAccount(userId);
  }

  @override
  Future<ApiResult<void>> updateDeviceToken({
    required String fcmToken,
    required DevicePlatform devicePlatform,
  }) async {
    return await _dataSource.updateDeviceToken(
      fcmToken: fcmToken,
      devicePlatform: devicePlatform,
    );
  }

  Future<void> _saveAuthSession(AuthResponse response) async {
    await UserSession.saveUser({
      'accessToken': response.accessToken,
      'refreshToken': response.refreshToken,
      'user': response.user?.toJson(),
    });
  }
}
