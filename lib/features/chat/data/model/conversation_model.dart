import 'last_message_content_type.dart';
import 'media_type.dart';
import 'message_model.dart';

class ConversationModel {
  final String id;
  final bool isGroup;
  final bool isEmpty;
  final String initiatorId;
  final String initiatorName;
  final String? initiatorProfilePictureUrl;
  final String recipientId;
  final String recipientName;
  final String? recipientProfilePictureUrl;
  final String? lastMessageContent;
  final LastMessageContentType lastMessageContentType;
  final MediaType lastMessageMediaType;
  final DateTime? lastMessageDate;
  final int unreadMessageCount;
  final DateTime createdAt;
  final List<MessageModel>? messages;

  ConversationModel({
    required this.id,
    required this.isGroup,
    this.isEmpty = false,
    required this.initiatorId,
    required this.initiatorName,
    this.initiatorProfilePictureUrl,
    required this.recipientId,
    required this.recipientName,
    this.recipientProfilePictureUrl,
    this.lastMessageContent,
    this.lastMessageContentType = LastMessageContentType.text,
    this.lastMessageMediaType = MediaType.image,
    this.lastMessageDate,
    this.unreadMessageCount = 0,
    required this.createdAt,
    this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to string
    String? getString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return ConversationModel(
      id: getString(json['id'] ?? json['Id']) ?? '',
      isGroup: (json['isGroup'] ?? json['IsGroup'] ?? false) as bool,
      isEmpty: (json['isEmpty'] ?? json['IsEmpty'] ?? false) as bool,
      initiatorId: getString(json['initiatorId'] ?? json['InitiatorId']) ?? '',
      initiatorName: getString(json['initiatorName'] ?? json['InitiatorName']) ?? '',
      initiatorProfilePictureUrl: getString(
        json['initiatorProfilePictureUrl'] ?? json['InitiatorProfilePictureUrl'],
      ),
      recipientId: getString(json['recipientId'] ?? json['RecipientId']) ?? '',
      recipientName: getString(json['recipientName'] ?? json['RecipientName']) ?? '',
      recipientProfilePictureUrl: getString(
        json['recipientProfilePictureUrl'] ?? json['RecipientProfilePictureUrl'],
      ),
      lastMessageContent: getString(json['lastMessageContent'] ?? json['LastMessageContent']),
      lastMessageContentType: LastMessageContentType.fromValue(
        json['lastMessageContentType'] ?? json['LastMessageContentType'],
      ),
      lastMessageMediaType: MediaType.fromValue(
        json['lastMessageMediaType'] ?? json['LastMessageMediaType'],
      ),
      lastMessageDate: (json['lastMessageDate'] ?? json['LastMessageDate']) != null
          ? DateTime.tryParse((json['lastMessageDate'] ?? json['LastMessageDate']).toString())
          : null,
      unreadMessageCount: (json['unreadMessageCount'] ?? json['UnreadMessageCount'] ?? 0) as int,
      createdAt: (json['createdAt'] ?? json['CreatedAt']) != null
          ? (DateTime.tryParse((json['createdAt'] ?? json['CreatedAt']).toString()) ??
                DateTime.now())
          : DateTime.now(),
      messages: (json['messages'] ?? json['Messages']) != null
          ? ((json['messages'] ?? json['Messages']) as List)
                .map((i) => MessageModel.fromJson(i))
                .toList()
          : null,
    );
  }

  ConversationModel copyWith({
    String? lastMessageContent,
    LastMessageContentType? lastMessageContentType,
    MediaType? lastMessageMediaType,
    DateTime? lastMessageDate,
    int? unreadMessageCount,
    List<MessageModel>? messages,
    bool? isEmpty,
  }) {
    return ConversationModel(
      id: id,
      isGroup: isGroup,
      isEmpty: isEmpty ?? this.isEmpty,
      initiatorId: initiatorId,
      initiatorName: initiatorName,
      initiatorProfilePictureUrl: initiatorProfilePictureUrl,
      recipientId: recipientId,
      recipientName: recipientName,
      recipientProfilePictureUrl: recipientProfilePictureUrl,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageContentType: lastMessageContentType ?? this.lastMessageContentType,
      lastMessageMediaType: lastMessageMediaType ?? this.lastMessageMediaType,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      createdAt: createdAt,
      messages: messages ?? this.messages,
    );
  }
}
