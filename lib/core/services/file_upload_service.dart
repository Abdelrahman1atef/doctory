import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';

class FileUploadService {
  final ApiConsumer _apiConsumer;

  FileUploadService(this._apiConsumer);

  Future<ApiResult<T>> upload<T>({
    required String path,
    required Map<String, dynamic> data,
    T Function(Map<String, dynamic>)? parser,
    void Function(int, int)? onProgress,
  }) async {
    final multipartData = await _toMultipart(data);
    return _apiConsumer.uploadFile<T>(
      path: path,
      data: multipartData,
      parser: parser,
      onProgress: onProgress,
    );
  }

  Future<ApiResult<String>> uploadAttachment({
    required File file,
    required int fileType,
    required int place,
    void Function(int, int)? onProgress,
  }) {
    return upload<String>(
      path: 'attachments/upload',
      data: {
        'File': file,
        'Place': place,
        'FileType': fileType,
      },
      parser: (json) => (json['message'] ?? '').toString(),
      onProgress: onProgress,
    );
  }

  Future<ApiResult<List<String>>> uploadMultipleAttachments({
    required List<File> files,
    required String fieldName,
    required int place,
    void Function(int, int)? onProgress,
  }) async {
    final multipartFiles = await Future.wait(
      files.map((f) => MultipartFile.fromFile(f.path)).toList(),
    );
    return _apiConsumer.uploadFile<List<String>>(
      path: 'attachments/upload-multiple-attachments',
      data: {
        fieldName: multipartFiles,
        '${fieldName}Place': place,
      },
      parser: (json) {
        final data = json['data'] ?? json['Data'] ?? [];
        return (data as List).map((e) => e.toString()).toList();
      },
      onProgress: onProgress,
    );
  }

  Future<Map<String, dynamic>> _toMultipart(Map<String, dynamic> data) async {
    final result = <String, dynamic>{};
    for (final entry in data.entries) {
      if (entry.value is File) {
        result[entry.key] = await MultipartFile.fromFile(
          (entry.value as File).path,
        );
      } else if (entry.value is List<File>) {
        result[entry.key] = await Future.wait(
          (entry.value as List<File>)
              .map((f) => MultipartFile.fromFile(f.path)),
        );
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}
