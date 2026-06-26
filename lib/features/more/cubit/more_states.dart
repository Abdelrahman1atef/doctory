abstract class MoreStates {
  const MoreStates();
}

class MoreInitialState extends MoreStates {}

class LogoutLoadingState extends MoreStates {}

class LogoutSuccessState extends MoreStates {}

class LogoutErrorState extends MoreStates {
  final String message;
  LogoutErrorState(this.message);
}

class DeleteAccountLoadingState extends MoreStates {}

class DeleteAccountSuccessState extends MoreStates {}

class DeleteAccountErrorState extends MoreStates {
  final String message;
  const DeleteAccountErrorState(this.message);
}
