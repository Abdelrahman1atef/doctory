enum ReactionType {
  none(0),
  like(1),
  love(2),
  haha(3),
  wow(4),
  sad(5),
  angry(6);

  final int value;
  const ReactionType(this.value);

  static ReactionType fromValue(int value) {
    return ReactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReactionType.none,
    );
  }
}

class PostModel {
  final String id;
  final String content;
  final String authorId;
  final String? authorName;
  final String? authorImage;
  final String? authorRole;
  final bool isFreelanceDoctor;
  final String createdAt;
  final int reactionCount;
  final int commentCount;
  final List<MediaModel> media;
  final ReactionType myReaction;

  bool get isMedicalProfessional =>
      authorRole != null && authorRole != 'patient' || isFreelanceDoctor;

  PostModel({
    required this.id,
    required this.content,
    required this.authorId,
    this.authorName,
    this.authorImage,
    this.authorRole,
    this.isFreelanceDoctor = false,
    required this.createdAt,
    required this.reactionCount,
    required this.commentCount,
    required this.media,
    this.myReaction = ReactionType.none,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'],
      authorImage: json['authorProfileImageUrl'] ?? json['authorImage'],
      authorRole: json['authorRole'],
      isFreelanceDoctor: json['isFreelanceDoctor'] == true,
      createdAt: json['createdAt'] ?? '',
      reactionCount: json['reactionCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      media: json['media'] != null
          ? (json['media'] as List).map((i) => MediaModel.fromJson(i)).toList()
          : [],
      myReaction: json['myReaction'] != null
          ? ReactionType.fromValue(json['myReaction'])
          : (json['isLikedByMe'] == true
                ? ReactionType.like
                : ReactionType.none),
    );
  }

  PostModel copyWith({
    String? id,
    String? content,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? authorRole,
    bool? isFreelanceDoctor,
    String? createdAt,
    int? reactionCount,
    int? commentCount,
    List<MediaModel>? media,
    ReactionType? myReaction,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      authorRole: authorRole ?? this.authorRole,
      isFreelanceDoctor: isFreelanceDoctor ?? this.isFreelanceDoctor,
      createdAt: createdAt ?? this.createdAt,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      media: media ?? this.media,
      myReaction: myReaction ?? this.myReaction,
    );
  }
}

class MediaModel {
  final String? id;
  final String url;
  final dynamic type;

  MediaModel({this.id, required this.url, this.type});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      url: json['url'] ?? '',
      type: json['type'],
    );
  }

  String get fullUrl {
    if (url.startsWith('http')) return url;
    return 'https://doctory-icare.runasp.net/files/$url';
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      if (type != null) 'type': type,
    };
  }
}

class CommentModel {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String? authorName;
  final String? authorImage;
  final String createdAt;
  final int reactionCount;
  final int repliesCount;
  final ReactionType myReaction;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    this.authorName,
    this.authorImage,
    required this.createdAt,
    required this.reactionCount,
    required this.repliesCount,
    this.myReaction = ReactionType.none,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      createdAt: json['createdAt'] ?? '',
      reactionCount: json['reactionCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      myReaction: json['myReaction'] != null
          ? ReactionType.fromValue(json['myReaction'])
          : (json['isLikedByMe'] == true
                ? ReactionType.like
                : ReactionType.none),
    );
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? content,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? createdAt,
    int? reactionCount,
    int? repliesCount,
    ReactionType? myReaction,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      createdAt: createdAt ?? this.createdAt,
      reactionCount: reactionCount ?? this.reactionCount,
      repliesCount: repliesCount ?? this.repliesCount,
      myReaction: myReaction ?? this.myReaction,
    );
  }
}

class ReactionModel {
  final String userId;
  final String? userName;
  final ReactionType type;

  ReactionModel({required this.userId, this.userName, required this.type});

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['userId'] ?? '',
      userName: json['userName'],
      type: json['type'] != null
          ? ReactionType.fromValue(json['type'])
          : ReactionType.like,
    );
  }
}

class PaginatedData<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PaginatedData({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedData<T>(
      items: (json['items'] ?? json['Items']) != null
          ? ((json['items'] ?? json['Items']) as List)
                .map((i) => fromJsonT(i))
                .toList()
          : [],
      pageNumber: json['pageNumber'] ?? json['PageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? json['PageSize'] ?? 20,
      totalPages: json['totalPages'] ?? json['TotalPages'] ?? 1,
      totalCount: json['totalCount'] ?? json['TotalCount'] ?? 0,
      hasPreviousPage:
          json['hasPreviousPage'] ?? json['HasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? json['HasNextPage'] ?? false,
    );
  }
}
