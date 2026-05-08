import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';

abstract class CreatePostRepo {
  Future<ApiResult<String>> createPostWithMedia({
    required String content,
    required List<SelectedMediaModel> media,
  });
}

class CreatePostRepoImpl implements CreatePostRepo {
  final CreatePostRemoteDataSource remoteDataSource;

  CreatePostRepoImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<String>> createPostWithMedia({
    required String content,
    required List<SelectedMediaModel> media,
  }) async {
    try {
      List<Map<String, dynamic>> finalMedia = [];

      // Group images and videos for batch uploading
      final images = media.where((m) => m.type == MediaType.image).map((m) => m.file).toList();
      final videos = media.where((m) => m.type == MediaType.video).map((m) => m.file).toList();
      final others = media.where((m) => m.type == MediaType.audio || m.type == MediaType.file).toList();

      // Upload Images
      if (images.isNotEmpty) {
        if (images.length == 1) {
          final res = await remoteDataSource.uploadImage(images.first);
          res.fold(
            onSuccess: (fileName) => finalMedia.add({'url': fileName, 'type': 'IMAGE'}),
            onFailure: (failure) => throw Exception(failure.message),
          );
        } else {
          final res = await remoteDataSource.uploadMultipleImages(images);
          res.fold(
            onSuccess: (fileNames) {
              for (var fileName in fileNames) {
                finalMedia.add({'url': fileName, 'type': 'IMAGE'});
              }
            },
            onFailure: (failure) => throw Exception(failure.message),
          );
        }
      }

      // Upload Videos
      if (videos.isNotEmpty) {
        if (videos.length == 1) {
          final res = await remoteDataSource.uploadVideo(videos.first);
          res.fold(
            onSuccess: (fileName) => finalMedia.add({'url': fileName, 'type': 'VIDEO'}),
            onFailure: (failure) => throw Exception(failure.message),
          );
        } else {
          final res = await remoteDataSource.uploadMultipleVideos(videos);
          res.fold(
            onSuccess: (fileNames) {
              for (var fileName in fileNames) {
                finalMedia.add({'url': fileName, 'type': 'VIDEO'});
              }
            },
            onFailure: (failure) => throw Exception(failure.message),
          );
        }
      }

      // Upload Others (Audio, File) one by one
      for (var item in others) {
        if (item.type == MediaType.audio) {
          final res = await remoteDataSource.uploadAudio(item.file);
          res.fold(
            onSuccess: (fileName) => finalMedia.add({'url': fileName, 'type': 'AUDIO'}),
            onFailure: (failure) => throw Exception(failure.message),
          );
        } else if (item.type == MediaType.file) {
          final res = await remoteDataSource.uploadFile(item.file);
          res.fold(
            onSuccess: (fileName) => finalMedia.add({'url': fileName, 'type': 'FILE'}),
            onFailure: (failure) => throw Exception(failure.message),
          );
        }
      }

      // Finally, create the post
      return await remoteDataSource.createPost(
        content: content,
        media: finalMedia.isNotEmpty ? finalMedia : null,
      );
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
