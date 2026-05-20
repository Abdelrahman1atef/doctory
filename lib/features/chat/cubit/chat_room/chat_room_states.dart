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
  
  // Media Preview and Upload Status
  final String? selectedFilePath;
  final String? uploadedFileName;
  final int? uploadedMediaType;
  final bool isUploadingMedia;

  ChatRoomLoaded({
    required this.conversation,
    required this.messages,
    this.isOtherUserTyping = false,
    this.isOtherUserOnline = false,
    this.replyingToMessage,
    this.selectedFilePath,
    this.uploadedFileName,
    this.uploadedMediaType,
    this.isUploadingMedia = false,
  });

  ChatRoomLoaded copyWith({
    ConversationModel? conversation,
    List<MessageModel>? messages,
    bool? isOtherUserTyping,
    bool? isOtherUserOnline,
    MessageModel? replyingToMessage,
    String? selectedFilePath,
    String? uploadedFileName,
    int? uploadedMediaType,
    bool? isUploadingMedia,
    bool clearReply = false,
    bool clearMedia = false,
  }) {
    return ChatRoomLoaded(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
      replyingToMessage: clearReply ? null : (replyingToMessage ?? this.replyingToMessage),
      selectedFilePath: clearMedia ? null : (selectedFilePath ?? this.selectedFilePath),
      uploadedFileName: clearMedia ? null : (uploadedFileName ?? this.uploadedFileName),
      uploadedMediaType: clearMedia ? null : (uploadedMediaType ?? this.uploadedMediaType),
      isUploadingMedia: clearMedia ? false : (isUploadingMedia ?? this.isUploadingMedia),
    );
  }
}

class ChatRoomError extends ChatRoomState {
  final String message;
  ChatRoomError(this.message);
}
