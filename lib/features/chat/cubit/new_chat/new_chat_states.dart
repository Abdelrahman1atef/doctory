abstract class NewChatState {}

class NewChatInitial extends NewChatState {}

class NewChatSearchLoading extends NewChatState {}

class NewChatSearchLoaded extends NewChatState {
  final List<dynamic> users; // Replace with actual User model if available
  NewChatSearchLoaded(this.users);
}

class NewChatSearchError extends NewChatState {
  final String message;
  NewChatSearchError(this.message);
}

class NewChatCreating extends NewChatState {}

class NewChatCreated extends NewChatState {
  final String conversationId;
  NewChatCreated(this.conversationId);
}

class NewChatCreateError extends NewChatState {
  final String message;
  NewChatCreateError(this.message);
}
