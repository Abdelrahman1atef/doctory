import 'message_model.dart';

class ConversationModel {
  final String id;
  final bool isGroup;
  final String initiatorId;
  final String initiatorName;
  final String? initiatorProfilePictureUrl;
  final String recipientId;
  final String recipientName;
  final String? recipientProfilePictureUrl;
  final String? lastMessageContent;
  final DateTime? lastMessageDate;
  final int unreadMessageCount;
  final DateTime createdAt;
  final List<MessageModel>? messages;

  ConversationModel({
    required this.id,
    required this.isGroup,
    required this.initiatorId,
    required this.initiatorName,
    this.initiatorProfilePictureUrl,
    required this.recipientId,
    required this.recipientName,
    this.recipientProfilePictureUrl,
    this.lastMessageContent,
    this.lastMessageDate,
    this.unreadMessageCount = 0,
    required this.createdAt,
    this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      isGroup: json['isGroup'] ?? false,
      initiatorId: json['initiatorId'] ?? '',
      initiatorName: json['initiatorName'] ?? '',
      initiatorProfilePictureUrl: json['initiatorProfilePictureUrl'],
      recipientId: json['recipientId'] ?? '',
      recipientName: json['recipientName'] ?? '',
      recipientProfilePictureUrl: json['recipientProfilePictureUrl'],
      lastMessageContent: json['lastMessageContent'],
      lastMessageDate: json['lastMessageDate'] != null 
          ? DateTime.parse(json['lastMessageDate']) 
          : null,
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      messages: json['messages'] != null
          ? (json['messages'] as List).map((i) => MessageModel.fromJson(i)).toList()
          : null,
    );
  }

  ConversationModel copyWith({
    String? lastMessageContent,
    DateTime? lastMessageDate,
    int? unreadMessageCount,
    List<MessageModel>? messages,
  }) {
    return ConversationModel(
      id: id,
      isGroup: isGroup,
      initiatorId: initiatorId,
      initiatorName: initiatorName,
      initiatorProfilePictureUrl: initiatorProfilePictureUrl,
      recipientId: recipientId,
      recipientName: recipientName,
      recipientProfilePictureUrl: recipientProfilePictureUrl,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      createdAt: createdAt,
      messages: messages ?? this.messages,
    );
  }
}
