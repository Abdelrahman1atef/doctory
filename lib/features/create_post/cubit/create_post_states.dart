abstract class CreatePostStates {}

class CreatePostInitialState extends CreatePostStates {}

class CreatePostMediaUpdatedState extends CreatePostStates {}

class CreatePostLoadingState extends CreatePostStates {
  final String? message;
  CreatePostLoadingState({this.message});
}

class CreatePostSuccessState extends CreatePostStates {
  final String message;
  CreatePostSuccessState(this.message);
}

class CreatePostErrorState extends CreatePostStates {
  final String message;
  CreatePostErrorState(this.message);
}
