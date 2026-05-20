import '../../data/model/message_model.dart';
import '../../data/model/conversation_model.dart';

sealed class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final ConversationModel conversation;
  final List<MessageModel> messages;
  final bool isOtherUserTyping;
  final bool isOtherUserOnline;
  final MessageModel? replyingToMessage;

  ChatRoomLoaded({
    required this.conversation,
    required this.messages,
    this.isOtherUserTyping = false,
    this.isOtherUserOnline = false,
    this.replyingToMessage,
  });
}

class ChatRoomError extends ChatRoomState {
  final String message;
  ChatRoomError(this.message);
}
