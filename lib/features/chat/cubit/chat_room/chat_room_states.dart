import '../../data/model/message_model.dart';
import '../../data/model/conversation_model.dart';

abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final ConversationModel conversation;
  final List<MessageModel> messages;
  final bool isOtherUserTyping;
  final bool isOtherUserOnline;

  ChatRoomLoaded({
    required this.conversation,
    required this.messages,
    this.isOtherUserTyping = false,
    this.isOtherUserOnline = false,
  });

  ChatRoomLoaded copyWith({
    ConversationModel? conversation,
    List<MessageModel>? messages,
    bool? isOtherUserTyping,
    bool? isOtherUserOnline,
  }) {
    return ChatRoomLoaded(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
    );
  }
}

class ChatRoomError extends ChatRoomState {
  final String message;
  ChatRoomError(this.message);
}
