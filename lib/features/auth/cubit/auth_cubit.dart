import 'package:doctory/features/auth/cubit/auth_states.dart';
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

  AuthCubit(this._authRepo, this._socialAuthService)
    : super(AuthInitialState());

  void login({required String email, required String password}) async {
    emit(AuthLoadingState());

    final result = await _authRepo.login(
      LoginRequest(email: email, password: password),
    );

    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void signup(
    SignupRequest request, {
    String? certificateImagePath,
    String? syndicateIdImagePath,
  }) async {
    emit(AuthLoadingState());

    final result = await _authRepo.signup(
      request,
      certificateImagePath: certificateImagePath,
      syndicateIdImagePath: syndicateIdImagePath,
    );

    result.fold(
      onSuccess: (data) => emit(SignupSuccessState(request.email)),
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
}
