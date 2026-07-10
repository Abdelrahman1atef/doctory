import 'dart:io';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/services/file_upload_service.dart';

abstract class CreatePostRemoteDataSource {
  Future<ApiResult<String>> uploadImage(File file, {int place = 2});
  Future<ApiResult<String>> uploadVideo(File file, {int place = 3});
  Future<ApiResult<String>> uploadAudio(File file, {int place = 4});
  Future<ApiResult<String>> uploadFile(File file, {int place = 4});

  Future<ApiResult<List<String>>> uploadMultipleImages(
    List<File> files, {
    int place = 2,
  });
  Future<ApiResult<List<String>>> uploadMultipleVideos(
    List<File> files, {
    int place = 3,
  });

  Future<ApiResult<String>> createPost({
    required String content,
    List<Map<String, dynamic>>? media,
  });
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final ApiConsumer apiConsumer;
  final FileUploadService _fileUploadService;

  CreatePostRemoteDataSourceImpl({required this.apiConsumer, required FileUploadService fileUploadService})
    : _fileUploadService = fileUploadService;

  @override
  Future<ApiResult<String>> uploadImage(File file, {int place = 2}) async {
    return _fileUploadService.uploadAttachment(file: file, fileType: 0, place: place);
  }

  @override
  Future<ApiResult<String>> uploadVideo(File file, {int place = 3}) async {
    return _fileUploadService.uploadAttachment(file: file, fileType: 1, place: place);
  }

  @override
  Future<ApiResult<String>> uploadAudio(File file, {int place = 4}) async {
    return _fileUploadService.uploadAttachment(file: file, fileType: 2, place: place);
  }

  @override
  Future<ApiResult<String>> uploadFile(File file, {int place = 4}) async {
    return _fileUploadService.uploadAttachment(file: file, fileType: 3, place: place);
  }

  @override
  Future<ApiResult<List<String>>> uploadMultipleImages(
    List<File> files, {
    int place = 2,
  }) async {
    return _fileUploadService.uploadMultipleAttachments(files: files, fieldName: 'Images', place: place);
  }

  @override
  Future<ApiResult<List<String>>> uploadMultipleVideos(
    List<File> files, {
    int place = 3,
  }) async {
    return _fileUploadService.uploadMultipleAttachments(files: files, fieldName: 'Videos', place: place);
  }

  @override
  Future<ApiResult<String>> createPost({
    required String content,
    List<Map<String, dynamic>>? media,
  }) async {
    return await apiConsumer.post<String>(
      path: 'posts/create',
      body: {'content': content, if (media != null) 'media': media},
      parser: (json) => (json['data'] ?? json['Data'] ?? json).toString(),
    );
  }
}
