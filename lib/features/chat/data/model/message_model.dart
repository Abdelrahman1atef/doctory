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
    this.media,
    this.reactions,
    this.isLocalPending = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderProfilePictureUrl: json['senderProfilePictureUrl'],
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      status: json['status']?.toString() ?? 'Sent',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      isEdited: json['isEdited'] ?? false,
      conversationId: json['conversationId'] ?? '',
      replyToMessageId: json['replyToMessageId'],
      replyToMessage: json['replyToMessage'] != null 
          ? MessageModel.fromJson(json['replyToMessage']) 
          : null,
      media: json['media'] != null 
          ? (json['media'] as List).map((i) => MediaModel.fromJson(i)).toList() 
          : null,
      reactions: json['reactions'] != null 
          ? (json['reactions'] as List).map((i) => ReactionModel.fromJson(i)).toList() 
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
      media: media,
      reactions: reactions ?? this.reactions,
      isLocalPending: isLocalPending,
    );
  }
}
