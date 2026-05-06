class PostModel {
  final String id;
  final String content;
  final String authorId;
  final String? authorName;
  final String? authorImage;
  final String createdAt;
  final int reactionCount;
  final int commentCount;
  final List<MediaModel> media;
  final bool isLikedByMe; // Default to false if not provided

  PostModel({
    required this.id,
    required this.content,
    required this.authorId,
    this.authorName,
    this.authorImage,
    required this.createdAt,
    required this.reactionCount,
    required this.commentCount,
    required this.media,
    this.isLikedByMe = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      createdAt: json['createdAt'] ?? '',
      reactionCount: json['reactionCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      media: json['media'] != null
          ? (json['media'] as List).map((i) => MediaModel.fromJson(i)).toList()
          : [],
      isLikedByMe: json['isLikedByMe'] ?? false,
    );
  }

  PostModel copyWith({
    String? id,
    String? content,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? createdAt,
    int? reactionCount,
    int? commentCount,
    List<MediaModel>? media,
    bool? isLikedByMe,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      createdAt: createdAt ?? this.createdAt,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      media: media ?? this.media,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

class MediaModel {
  final String? id;
  final String url;
  final dynamic type;

  MediaModel({
    this.id,
    required this.url,
    this.type,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      url: json['url'] ?? '',
      type: json['type'],
    );
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
  final bool isLikedByMe;

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
    this.isLikedByMe = false,
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
      isLikedByMe: json['isLikedByMe'] ?? false,
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
    bool? isLikedByMe,
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
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

class ReactionModel {
  final String userId;
  final String? userName;
  final String type;

  ReactionModel({
    required this.userId,
    this.userName,
    required this.type,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['userId'] ?? '',
      userName: json['userName'],
      type: json['type']?.toString() ?? '',
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
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginatedData<T>(
      items: json['items'] != null
          ? (json['items'] as List).map((i) => fromJsonT(i)).toList()
          : [],
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
