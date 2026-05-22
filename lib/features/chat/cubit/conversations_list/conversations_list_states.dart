import '../../data/model/conversation_model.dart';

sealed class ConversationsListState {}

class ConversationsListInitial extends ConversationsListState {}

class ConversationsListLoading extends ConversationsListState {}

class ConversationsListLoaded extends ConversationsListState {
  final List<ConversationModel> conversations;
  final Set<String> onlineUserIds;
  final Set<String> typingUserIds;

  ConversationsListLoaded({
    required this.conversations,
    required this.onlineUserIds,
    this.typingUserIds = const {},
  });
}

class ConversationsListError extends ConversationsListState {
  final String message;
  ConversationsListError(this.message);
}
