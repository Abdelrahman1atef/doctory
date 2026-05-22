import 'media_model.dart';
import 'reaction_model.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderProfilePictureUrl;
  final String content;
  final bool isRead;
  final DateTime? readAt;
  final String status;
  final DateTime createdAt;
  final DateTime? editedAt;
  final bool isEdited;
  final String conversationId;
  final String? replyToMessageId;
  final MessageModel? replyToMessage;
  final String? mediaPreview;
  final List<MediaModel>? media;
  final List<ReactionModel>? reactions;

  // Local state for optimistic updates
  final bool isLocalPending;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderProfilePictureUrl,
    required this.content,
    required this.isRead,
    this.readAt,
    required this.status,
    required this.createdAt,
    this.editedAt,
    required this.isEdited,
    required this.conversationId,
    this.replyToMessageId,
    this.replyToMessage,
    this.mediaPreview,
    this.media,
    this.reactions,
    this.isLocalPending = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] ?? json['Id'] ?? '').toString(),
      senderId: (json['senderId'] ?? json['SenderId'] ?? '').toString(),
      senderName: (json['senderName'] ?? json['SenderName'] ?? '').toString(),
      senderProfilePictureUrl: json['senderProfilePictureUrl'] ?? json['SenderProfilePictureUrl'],
      content: (json['content'] ?? json['Content'] ?? '').toString(),
      isRead: json['isRead'] ?? json['IsRead'] ?? false,
      readAt: (json['readAt'] ?? json['ReadAt']) != null 
          ? DateTime.parse(json['readAt'] ?? json['ReadAt']) 
          : null,
      status: (json['status'] ?? json['Status'] ?? 'Sent').toString(),
      createdAt: (json['createdAt'] ?? json['CreatedAt']) != null 
          ? DateTime.parse(json['createdAt'] ?? json['CreatedAt']) 
          : DateTime.now(),
      editedAt: (json['editedAt'] ?? json['EditedAt']) != null 
          ? DateTime.parse(json['editedAt'] ?? json['EditedAt']) 
          : null,
      isEdited: json['isEdited'] ?? json['IsEdited'] ?? false,
      conversationId: (json['conversationId'] ?? json['ConversationId'] ?? '').toString(),
      replyToMessageId: (json['replyToMessageId'] ?? json['ReplyToMessageId'])?.toString(),
      replyToMessage: (json['replyToMessage'] ?? json['ReplyToMessage']) != null 
          ? MessageModel.fromJson(json['replyToMessage'] ?? json['ReplyToMessage']) 
          : null,
      mediaPreview: json['mediaPreview'] ?? json['MediaPreview'],
      media: (json['media'] ?? json['Media']) != null 
          ? ( (json['media'] ?? json['Media']) as List).map((i) => MediaModel.fromJson(i)).toList() 
          : null,
      reactions: (json['reactions'] ?? json['Reactions']) != null 
          ? ( (json['reactions'] ?? json['Reactions']) as List).map((i) => ReactionModel.fromJson(i)).toList() 
          : null,
    );
  }

  MessageModel copyWith({
    String? status,
    bool? isRead,
    DateTime? readAt,
    List<ReactionModel>? reactions,
  }) {
    return MessageModel(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderProfilePictureUrl: senderProfilePictureUrl,
      content: content,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      status: status ?? this.status,
      createdAt: createdAt,
      editedAt: editedAt,
      isEdited: isEdited,
      conversationId: conversationId,
      replyToMessageId: replyToMessageId,
      replyToMessage: replyToMessage,
      mediaPreview: mediaPreview,
      media: media,
      reactions: reactions ?? this.reactions,
      isLocalPending: isLocalPending,
    );
  }
}
