import '../../error/failures.dart';

/// Result type for API responses
class ApiResult<T> {
  final T? data;
  final Failure? failure;
  final bool _isSuccess;

  const ApiResult._({this.data, this.failure, required bool isSuccess}) : _isSuccess = isSuccess;

  factory ApiResult.success(T data) => ApiResult._(data: data, isSuccess: true);

  factory ApiResult.failure(Failure failure) => ApiResult._(failure: failure, isSuccess: false);

  bool get isSuccess => _isSuccess;

  bool get isFailure => !isSuccess;

  /// Fold pattern for handling results
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure!);
    }
  }

  /// Map the data if successful
  ApiResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return ApiResult.success(mapper(data as T));
      } catch (e) {
        return ApiResult.failure(UnknownFailure(message: 'Error mapping data'));
      }
    }
    return ApiResult.failure(failure!);
  }
}
