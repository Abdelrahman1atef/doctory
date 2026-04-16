import 'package:doctory/core/error/failures.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState<T> extends AuthStates {
  final T data;
  AuthSuccessState(this.data);
}

class AuthErrorState extends AuthStates {
  final String message;
  AuthErrorState(this.message);
}
