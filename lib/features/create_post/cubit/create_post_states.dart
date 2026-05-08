abstract class CreatePostStates {}

class CreatePostInitialState extends CreatePostStates {}

class CreatePostMediaUpdatedState extends CreatePostStates {}

class CreatePostErrorState extends CreatePostStates {
  final String message;
  CreatePostErrorState(this.message);
}
