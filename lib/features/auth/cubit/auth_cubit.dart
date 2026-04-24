import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:doctory/features/auth/data/model/login_request.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitialState());

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

  void signup(SignupRequest request) async {
    emit(AuthLoadingState());

    final result = await _authRepo.signup(request);

    result.fold(
      onSuccess: (data) => emit(SignupSuccessState(request.email)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  void verify(String email, String code) async {
    emit(AuthLoadingState());

    final result = await _authRepo.verify(email, code);

    result.fold(
      onSuccess: (_) => emit(VerifySuccessState()),
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

  void socialLogin({
    required String provider,
    required String accessToken,
    String? name,
    String? email,
  }) async {
    emit(AuthLoadingState());

    final result = await _authRepo.socialLogin(
      provider: provider,
      accessToken: accessToken,
      name: name,
      email: email,
    );

    result.fold(
      onSuccess: (data) => emit(AuthSuccessState(data)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> verifyResetToken(String email, String token) async {
    emit(AuthLoadingState());
    final result = await _authRepo.verifyResetToken(email, token);
    result.fold(
      onSuccess: (isValid) => emit(ResetTokenVerifiedState(isValid)),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }

  Future<void> resetPassword(String email, String token, String newPassword) async {
    emit(AuthLoadingState());
    final result = await _authRepo.resetPassword(email, token, newPassword);
    result.fold(
      onSuccess: (_) => emit(ResetPasswordSuccessState()),
      onFailure: (failure) => emit(AuthErrorState(failure.userMessage)),
    );
  }
}
