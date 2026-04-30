abstract class MoreStates {}

class MoreInitialState extends MoreStates {}

class LogoutLoadingState extends MoreStates {}

class LogoutSuccessState extends MoreStates {}

class LogoutErrorState extends MoreStates {
  final String message;
  LogoutErrorState(this.message);
}
