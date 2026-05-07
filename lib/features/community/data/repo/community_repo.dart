import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/community/data/data_source/community_remote_data_source.dart';
import 'package:doctory/features/community/data/model/community_models.dart';

abstract class CommunityRepo {
  // Posts
  Future<ApiResult<PaginatedData<PostModel>>> getPosts({int pageNumber = 1, int pageSize = 20});
  Future<ApiResult<PostModel>> getPostById(String id);
  Future<ApiResult<String>> createPost({required String content, List<Map<String, dynamic>>? media});
  Future<ApiResult<String>> updatePost({required String postId, required String content});
  Future<ApiResult<bool>> deletePost(String postId);
  Future<ApiResult<bool>> togglePostReaction(String postId, {int type = 0});
  Future<ApiResult<PaginatedData<ReactionModel>>> getPostReactions(String postId, {int pageNumber = 1, int pageSize = 20});

  // Comments
  Future<ApiResult<PaginatedData<CommentModel>>> getCommentsByPost(String postId, {int pageNumber = 1, int pageSize = 20});
  Future<ApiResult<String>> createComment({required String postId, required String content, String? parentCommentId});
  Future<ApiResult<String>> updateComment({required String commentId, required String content});
  Future<ApiResult<bool>> deleteComment(String commentId);
  Future<ApiResult<bool>> toggleCommentReaction(String commentId, {int type = 0});
}

class CommunityRepoImpl implements CommunityRepo {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepoImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<PaginatedData<PostModel>>> getPosts({int pageNumber = 1, int pageSize = 20}) async {
    try {
      return await remoteDataSource.getPosts(pageNumber: pageNumber, pageSize: pageSize);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<PostModel>> getPostById(String id) async {
    try {
      return await remoteDataSource.getPostById(id);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<String>> createPost({required String content, List<Map<String, dynamic>>? media}) async {
    try {
      return await remoteDataSource.createPost(content: content, media: media);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<String>> updatePost({required String postId, required String content}) async {
    try {
      return await remoteDataSource.updatePost(postId: postId, content: content);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> deletePost(String postId) async {
    try {
      return await remoteDataSource.deletePost(postId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> togglePostReaction(String postId, {int type = 0}) async {
    try {
      return await remoteDataSource.togglePostReaction(postId, type: type);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<PaginatedData<ReactionModel>>> getPostReactions(String postId, {int pageNumber = 1, int pageSize = 20}) async {
    try {
      return await remoteDataSource.getPostReactions(postId, pageNumber: pageNumber, pageSize: pageSize);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<PaginatedData<CommentModel>>> getCommentsByPost(String postId, {int pageNumber = 1, int pageSize = 20}) async {
    try {
      return await remoteDataSource.getCommentsByPost(postId, pageNumber: pageNumber, pageSize: pageSize);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<String>> createComment({required String postId, required String content, String? parentCommentId}) async {
    try {
      return await remoteDataSource.createComment(postId: postId, content: content, parentCommentId: parentCommentId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<String>> updateComment({required String commentId, required String content}) async {
    try {
      return await remoteDataSource.updateComment(commentId: commentId, content: content);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> deleteComment(String commentId) async {
    try {
      return await remoteDataSource.deleteComment(commentId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> toggleCommentReaction(String commentId, {int type = 0}) async {
    try {
      return await remoteDataSource.toggleCommentReaction(commentId, type: type);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
