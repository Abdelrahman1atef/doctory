import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';

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

  CreatePostRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<String>> uploadImage(File file, {int place = 2}) async {
    return await apiConsumer.uploadFile<String>(
      path: 'attachments/upload-image',
      data: {'File': await MultipartFile.fromFile(file.path), 'Place': place},
      parser: (json) => (json['message'] ?? json['Message'] ?? '').toString(),
    );
  }

  @override
  Future<ApiResult<String>> uploadVideo(File file, {int place = 3}) async {
    return await apiConsumer.uploadFile<String>(
      path: 'attachments/upload-video',
      data: {'File': await MultipartFile.fromFile(file.path), 'Place': place},
      parser: (json) => (json['message'] ?? json['Message'] ?? '').toString(),
    );
  }

  @override
  Future<ApiResult<String>> uploadAudio(File file, {int place = 4}) async {
    return await apiConsumer.uploadFile<String>(
      path: 'attachments/upload-audio',
      data: {'File': await MultipartFile.fromFile(file.path), 'Place': place},
      parser: (json) => (json['message'] ?? json['Message'] ?? '').toString(),
    );
  }

  @override
  Future<ApiResult<String>> uploadFile(File file, {int place = 4}) async {
    return await apiConsumer.uploadFile<String>(
      path: 'attachments/upload-file',
      data: {'File': await MultipartFile.fromFile(file.path), 'Place': place},
      parser: (json) => (json['message'] ?? json['Message'] ?? '').toString(),
    );
  }

  @override
  Future<ApiResult<List<String>>> uploadMultipleImages(
    List<File> files, {
    int place = 2,
  }) async {
    final multipartFiles = await Future.wait(
      files.map((f) => MultipartFile.fromFile(f.path)).toList(),
    );
    return await apiConsumer.uploadFile<List<String>>(
      path: 'attachments/upload-multiple-images',
      data: {'Files': multipartFiles, 'Place': place},
      parser: (json) {
        final data = json['data'] ?? json['Data'] ?? [];
        return (data as List).map((e) => e.toString()).toList();
      },
    );
  }

  @override
  Future<ApiResult<List<String>>> uploadMultipleVideos(
    List<File> files, {
    int place = 3,
  }) async {
    final multipartFiles = await Future.wait(
      files.map((f) => MultipartFile.fromFile(f.path)).toList(),
    );
    return await apiConsumer.uploadFile<List<String>>(
      path: 'attachments/upload-multiple-videos',
      data: {'Files': multipartFiles, 'Place': place},
      parser: (json) {
        final data = json['data'] ?? json['Data'] ?? [];
        return (data as List).map((e) => e.toString()).toList();
      },
    );
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
