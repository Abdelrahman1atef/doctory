import 'package:doctory/features/auth/data/model/user_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState<T> extends AuthStates {
  final T data;
  AuthSuccessState(this.data);
}

class SignupSuccessState extends AuthStates {
  final String email;
  SignupSuccessState(this.email);
}

class VerifySuccessState extends AuthStates {}

class ForgotPasswordSuccessState extends AuthStates {}

class ResetTokenVerifiedState extends AuthStates {
  final bool isValid;
  ResetTokenVerifiedState(this.isValid);
}

class ResetPasswordSuccessState extends AuthStates {}

class ProfileLoadedState extends AuthStates {
  final UserModel user;
  ProfileLoadedState(this.user);
}

class ProfileUpdateSuccessState extends AuthStates {}

class LanguageUpdateSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String message;
  AuthErrorState(this.message);
}
