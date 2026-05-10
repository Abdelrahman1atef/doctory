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
      id: (json['id'] ?? json['Id'] ?? '').toString(),
      isGroup: json['isGroup'] ?? json['IsGroup'] ?? false,
      initiatorId: (json['initiatorId'] ?? json['InitiatorId'] ?? '').toString(),
      initiatorName: (json['initiatorName'] ?? json['InitiatorName'] ?? '').toString(),
      initiatorProfilePictureUrl: json['initiatorProfilePictureUrl'] ?? json['InitiatorProfilePictureUrl'],
      recipientId: (json['recipientId'] ?? json['RecipientId'] ?? '').toString(),
      recipientName: (json['recipientName'] ?? json['RecipientName'] ?? '').toString(),
      recipientProfilePictureUrl: json['recipientProfilePictureUrl'] ?? json['RecipientProfilePictureUrl'],
      lastMessageContent: json['lastMessageContent'] ?? json['LastMessageContent'],
      lastMessageDate: (json['lastMessageDate'] ?? json['LastMessageDate']) != null 
          ? DateTime.parse(json['lastMessageDate'] ?? json['LastMessageDate']) 
          : null,
      unreadMessageCount: json['unreadMessageCount'] ?? json['UnreadMessageCount'] ?? 0,
      createdAt: (json['createdAt'] ?? json['CreatedAt']) != null 
          ? DateTime.parse(json['createdAt'] ?? json['CreatedAt']) 
          : DateTime.now(),
      messages: (json['messages'] ?? json['Messages']) != null
          ? ((json['messages'] ?? json['Messages']) as List).map((i) => MessageModel.fromJson(i)).toList()
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
