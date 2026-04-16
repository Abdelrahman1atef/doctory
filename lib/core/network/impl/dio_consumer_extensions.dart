import '../interfaces/api_result.dart';
import 'dio_consumer.dart';

/// Extension for backward compatibility with legacy method names
extension DioConsumerLegacyExtensions on DioConsumer {
  Future<ApiResult<T?>> getData<T>({
    required String url,
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic>)? parser,
    bool loading = false,
  }) {
    return get<T>(
      path: url,
      queryParameters: query,
      parser: parser,
      showLoading: loading,
    );
  }

  Future<ApiResult<T?>> postData<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    bool isFile = false,
    T Function(Map<String, dynamic>)? parser,
  }) {
    return post<T>(
      path: url,
      body: body,
      queryParameters: query,
      showLoading: loading,
      isFormData: isForm || isFile,
      parser: parser,
    );
  }

  Future<ApiResult<T?>> putData<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    T Function(Map<String, dynamic>)? parser,
  }) {
    return put<T>(
      path: url,
      body: body,
      queryParameters: query,
      showLoading: loading,
      isFormData: isForm,
      parser: parser,
    );
  }

  Future<ApiResult<T?>> deleteData<T>({
    required String url,
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic>)? parser,
    bool loading = false,
  }) {
    return delete<T>(
      path: url,
      queryParameters: query,
      parser: parser,
      showLoading: loading,
    );
  }
}
