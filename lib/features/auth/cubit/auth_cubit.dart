import 'dart:io';

import 'package:doctory/core/enums/device_platform.dart';
import 'package:doctory/core/services/file_upload_service.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:doctory/features/auth/data/model/clinic_setup_request.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/model/update_profile_request.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/services/social_auth_service.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo _authRepo;
  final SocialAuthService _socialAuthService;
  final FileUploadService _fileUploadService;

  AuthCubit(this._authRepo, this._socialAuthService, this._fileUploadService)
    : super(AuthInitialState());

  DevicePlatform get _currentPlatform {
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isIOS) return DevicePlatform.iOS;
    return DevicePlatform.web;
  }

  void login({required String email, required String password}) async {
    emit(AuthLoadingState());

    final result = await _authRepo.login(
      LoginRequest(
        email: email,
        password: password,
        fcmToken: UserSession.fcmToken.isNotEmpty ? UserSession.fcmToken : null,
        devicePlatform: _currentPlatform,
      ),
    );

    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<String?> _uploadFile(File file, int fileType, int place) async {
    final result = await _fileUploadService.uploadAttachment(
      file: file,
      fileType: fileType,
      place: place,
    );
    return result.fold(
      onSuccess: (name) => name,
      onFailure: (failure) {
        emit(AuthErrorState(failure.userMessage));
        return null;
      },
    );
  }

  void signup({
    required SignupRequest request,
    File? doctorImageFile,
    File? professionalPracticeCardFile,
    File? unionIdFile,
    File? taxCardFile,
    File? commercialRegisterFile,
  }) async {
    emit(AuthLoadingState());

    String? doctorImage;
    String? professionalPracticeCardImage;
    String? unionIdImage;
    String? taxCardImage;
    String? commercialRegisterImage;

    if (doctorImageFile != null) {
      doctorImage = await _uploadFile(doctorImageFile, 0, 1);
      if (state is AuthErrorState) return;
    }
    if (professionalPracticeCardFile != null) {
      professionalPracticeCardImage = await _uploadFile(professionalPracticeCardFile, 0, 5);
      if (state is AuthErrorState) return;
    }
    if (unionIdFile != null) {
      unionIdImage = await _uploadFile(unionIdFile, 0, 6);
      if (state is AuthErrorState) return;
    }
    if (taxCardFile != null) {
      taxCardImage = await _uploadFile(taxCardFile, 0, 7);
      if (state is AuthErrorState) return;
    }
    if (commercialRegisterFile != null) {
      commercialRegisterImage = await _uploadFile(commercialRegisterFile, 0, 8);
      if (state is AuthErrorState) return;
    }

    final updatedRequest = SignupRequest(
      fullName: request.fullName,
      email: request.email,
      password: request.password,
      confirmPassword: request.confirmPassword,
      phoneNumber: request.phoneNumber,
      typeOfUser: request.typeOfUser,
      birthDate: request.birthDate,
      gender: request.gender,
      fcmToken: UserSession.fcmToken.isNotEmpty ? UserSession.fcmToken : null,
      devicePlatform: _currentPlatform,
      doctorImage: doctorImage,
      professionalPracticeCardImage: professionalPracticeCardImage,
      unionIdImage: unionIdImage,
      taxCardImage: taxCardImage,
      commercialRegisterImage: commercialRegisterImage,
    );

    final result = await _authRepo.signup(updatedRequest);

    result.fold(
      onSuccess: (data) {
        if (data.accessToken.isEmpty && data.user == null) {
          emit(SignupPendingState());
        } else {
          emit(SignupSuccessState(request.email));
        }
      },
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void verify(String email, String code) async {
    emit(AuthLoadingState());

    final result = await _authRepo.verify(email, code);

    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void forgotPassword(String email) async {
    emit(AuthLoadingState());

    final result = await _authRepo.forgotPassword(email);

    result.fold(
      onSuccess: (_) => emit(ForgotPasswordSuccessState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void loginFacebook(String accessToken) async {
    emit(AuthLoadingState());
    final result = await _authRepo.loginFacebook(accessToken);
    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void completeFacebookRegistration(String accessToken, String email) async {
    emit(AuthLoadingState());
    final result = await _authRepo.completeFacebookRegistration(
      accessToken: accessToken,
      email: email,
    );
    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void loginGoogle(String idToken) async {
    emit(AuthLoadingState());
    final result = await _authRepo.loginGoogle(idToken);
    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void signInWithGoogle() async {
    emit(AuthLoadingState());
    final result = await _socialAuthService.signInWithGoogle();
    if (result != null && result.idToken != null) {
      loginGoogle(result.idToken!);
    } else {
      emit(AuthInitialState());
    }
  }

  void signInWithFacebook() async {
    emit(AuthLoadingState());
    final result = await _socialAuthService.signInWithFacebook();
    if (result != null && result.accessToken.isNotEmpty) {
      loginFacebook(result.accessToken);
    } else {
      emit(AuthInitialState());
    }
  }

  Future<void> verifyResetToken(String email, String token) async {
    emit(AuthLoadingState());
    final result = await _authRepo.verifyResetToken(email, token);
    result.fold(
      onSuccess: (isValid) => emit(ResetTokenVerifiedState(isValid)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoadingState());
    final result = await _authRepo.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    result.fold(
      onSuccess: (_) => emit(ResetPasswordSuccessState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> getProfile() async {
    emit(AuthLoadingState());
    final result = await _authRepo.getProfile();
    result.fold(
      onSuccess: (user) {
        _populateSession(user);
        emit(ProfileLoadedState(user));
      },
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void _populateSession(UserModel user) {
    if (user.userRole != null) {
      UserSession.currentRole = user.userRole;
    }
    if (user.permissions != null) {
      UserSession.currentPermissions = user.permissions!.toSet();
    }
    UserSession.currentDoctorType = user.doctorType;
  }

  Future<void> updateProfile(UpdateProfileRequest request) async {
    emit(AuthLoadingState());
    final result = await _authRepo.updateProfile(request);
    result.fold(
      onSuccess: (_) => emit(ProfileUpdateSuccessState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> updateLanguage(int language) async {
    emit(AuthLoadingState());
    final result = await _authRepo.updateLanguage(language);
    result.fold(
      onSuccess: (_) => emit(LanguageUpdateSuccessState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> registerClinic(ClinicSetupRequest request) async {
    emit(AuthLoadingState());
    final result = await _authRepo.registerClinic(request);
    result.fold(
      onSuccess: (_) => emit(ClinicRegisteredState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> updateDeviceToken() async {
    final fcmToken = UserSession.fcmToken;
    if (fcmToken.isEmpty) return;

    final result = await _authRepo.updateDeviceToken(
      fcmToken: fcmToken,
      devicePlatform: _currentPlatform,
    );
    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {},
    );
  }
}
