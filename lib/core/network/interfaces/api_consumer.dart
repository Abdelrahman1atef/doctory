import 'api_result.dart';
export 'api_result.dart';

/// Abstract API consumer interface
/// All network implementations should implement this interface
abstract class ApiConsumer {
  /// GET request
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
    dynamic cancelToken,
  });

  /// POST request
  Future<ApiResult<T>> post<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// PUT request
  Future<ApiResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// PATCH request
  Future<ApiResult<T>> patch<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// DELETE request
  Future<ApiResult<T>> delete<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  });

  /// Upload file
  Future<ApiResult<T>> uploadFile<T>({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    void Function(int sent, int total)? onProgress,
    bool showLoading = false,
  });

  /// Download file
  Future<ApiResult<String>> downloadFile({
    required String path,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onProgress,
    bool showLoading = false,
  });
}
