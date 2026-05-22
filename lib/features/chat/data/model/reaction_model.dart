class ReactionModel {
  final String id;
  final String userId;
  final String userName;
  final String reactionType;

  ReactionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.reactionType,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      reactionType: (json['reactionType'] ?? '').toString(),
    );
  }
}
