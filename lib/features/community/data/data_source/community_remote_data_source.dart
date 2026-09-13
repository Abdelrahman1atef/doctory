import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/community/data/model/community_models.dart';

abstract class CommunityRemoteDataSource {
  // Posts
  Future<ApiResult<PaginatedData<PostModel>>> getPosts({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<ApiResult<PostModel>> getPostById(String id);

  Future<ApiResult<String>> updatePost({
    required String postId,
    required String content,
  });

  Future<ApiResult<bool>> deletePost(String postId);

  Future<ApiResult<bool>> togglePostReaction(String postId, {int type = 0});

  Future<ApiResult<PaginatedData<ReactionModel>>> getPostReactions(
    String postId, {
    int pageNumber = 1,
    int pageSize = 20,
  });

  // Comments
  Future<ApiResult<PaginatedData<CommentModel>>> getCommentsByPost(
    String postId, {
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<ApiResult<String>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<ApiResult<String>> updateComment({
    required String commentId,
    required String content,
  });

  Future<ApiResult<bool>> deleteComment(String commentId);

  Future<ApiResult<bool>> toggleCommentReaction(
    String commentId, {
    int type = 0,
  });
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiConsumer apiConsumer;

  CommunityRemoteDataSourceImpl({required this.apiConsumer});

  // --- Posts ---
  @override
  Future<ApiResult<PaginatedData<PostModel>>> getPosts({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return await apiConsumer.get<PaginatedData<PostModel>>(
      path: 'posts/pagginated',
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
      parser: (json) {
        return PaginatedData.fromJson(json, (item) => PostModel.fromJson(item));
      },
    );
  }

  @override
  Future<ApiResult<PostModel>> getPostById(String id) async {
    return await apiConsumer.get<PostModel>(
      path: 'posts/$id',
      parser: (json) => PostModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  Future<ApiResult<String>> updatePost({
    required String postId,
    required String content,
  }) async {
    return await apiConsumer.put<String>(
      path: 'posts/update',
      body: {'postId': postId, 'content': content},
      parser: (json) => (json['data'] ?? json['Data'] ?? json).toString(),
    );
  }

  @override
  Future<ApiResult<bool>> deletePost(String postId) async {
    return await apiConsumer.delete<bool>(
      path: 'posts/delete',
      body: {'postId': postId},
      parser: (json) => (json['success'] ?? json['Success'] ?? json) == true,
    );
  }

  @override
  Future<ApiResult<bool>> togglePostReaction(
    String postId, {
    int type = 0,
  }) async {
    return await apiConsumer.post<bool>(
      path: 'posts/$postId/reactions',
      body: {'type': type},
      parser: (json) => (json['success'] ?? json['Success'] ?? json) == true,
    );
  }

  @override
  Future<ApiResult<PaginatedData<ReactionModel>>> getPostReactions(
    String postId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return await apiConsumer.get<PaginatedData<ReactionModel>>(
      path: 'posts/$postId/reactions',
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
      parser: (json) {
        return PaginatedData.fromJson(
          json,
          (item) => ReactionModel.fromJson(item),
        );
      },
    );
  }

  // --- Comments ---
  @override
  Future<ApiResult<PaginatedData<CommentModel>>> getCommentsByPost(
    String postId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return await apiConsumer.get<PaginatedData<CommentModel>>(
      path: 'comments/post/$postId',
      queryParameters: {'PageNumber': pageNumber, 'PageSize': pageSize},
      parser: (json) {
        return PaginatedData.fromJson(
          json,
          (item) => CommentModel.fromJson(item),
        );
      },
    );
  }

  @override
  Future<ApiResult<String>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    return await apiConsumer.post<String>(
      path: 'comments/create',
      body: {
        'postId': postId,
        'content': content,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      },
      parser: (json) => (json['data'] ?? json['Data'] ?? json).toString(),
    );
  }

  @override
  Future<ApiResult<String>> updateComment({
    required String commentId,
    required String content,
  }) async {
    return await apiConsumer.put<String>(
      path: 'comments/update',
      body: {'commentId': commentId, 'content': content},
      parser: (json) => (json['data'] ?? json['Data'] ?? json).toString(),
    );
  }

  @override
  Future<ApiResult<bool>> deleteComment(String commentId) async {
    return await apiConsumer.delete<bool>(
      path: 'comments/delete',
      body: {'commentId': commentId},
      parser: (json) => (json['success'] ?? json['Success'] ?? json) == true,
    );
  }

  @override
  Future<ApiResult<bool>> toggleCommentReaction(
    String commentId, {
    int type = 0,
  }) async {
    return await apiConsumer.post<bool>(
      path: 'comments/$commentId/reactions',
      queryParameters: {'Type': type},
      parser: (json) => (json['success'] ?? json['Success'] ?? json) == true,
    );
  }
}
