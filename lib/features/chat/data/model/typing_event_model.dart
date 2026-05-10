class TypingEventModel {
  final String conversationId;
  final String userId;
  final bool isTyping;

  TypingEventModel({
    required this.conversationId,
    required this.userId,
    required this.isTyping,
  });

  factory TypingEventModel.fromJson(Map<String, dynamic> json) {
    return TypingEventModel(
      conversationId: json['conversationId'] ?? '',
      userId: json['userId'] ?? '',
      isTyping: json['isTyping'] ?? false,
    );
  }
}
