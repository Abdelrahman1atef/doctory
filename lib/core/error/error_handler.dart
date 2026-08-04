import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/services/crashlytics_service.dart';
import 'failures.dart';
import 'exceptions.dart';

/// Converts exceptions to failures
class ErrorHandler {
  /// Convert DioException to Failure
  static Failure handleDioException(DioException error) {
    final failure = _mapDioException(error);
    _reportIfBlocking(failure, error, error.stackTrace);
    return failure;
  }

  /// Internal mapping — pure conversion, no side effects
  static Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NoInternetFailure(
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        return NetworkFailure(
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.cancel:
        return UnknownFailure(
          message: 'request_cancelled'.tr(),
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: 'bad_certificate'.tr(),
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetFailure(
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        return UnknownFailure(
          message: error.message,
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Handle HTTP response errors based on status code
  static Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Extract message from response
    String? message;
    Map<String, List<String>>? validationErrors;

    if (data is Map<String, dynamic>) {
      // Handle various backend error formats
      message =
          data['message']?.toString() ??
          data['msg']?.toString() ??
          (data['error'] is Map
              ? data['error']['message']?.toString()
              : data['error']?.toString());

      // Extract validation errors
      if (data['errors'] is Map) {
        final errorsMap = data['errors'] as Map;
        validationErrors = errorsMap.map(
          (key, value) => MapEntry(
            key.toString(),
            value is List
                ? value.map((e) => e.toString()).toList()
                : [value.toString()],
          ),
        );

        // If no top-level message, use the first validation error
        if (message == null || message.isEmpty) {
          if (validationErrors.isNotEmpty) {
            message = validationErrors.values.first.first;
          }
        }
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        if (validationErrors != null && validationErrors.isNotEmpty) {
          return ValidationFailure(
            message: message,
            errors: validationErrors,
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        return BadRequestFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 401:
        return AuthFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 403:
        return PermissionFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 404:
        return NotFoundFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 422:
        return ValidationFailure(
          message: message,
          errors: validationErrors,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 429:
        return ServerFailure(
          message: 'too_many_requests'.tr(),
          code: 'TOO_MANY_REQUESTS',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      default:
        return UnknownFailure(
          message: message ?? 'unexpected_error_occurred'.tr(),
          code: 'HTTP_$statusCode',
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Convert app exceptions to failures
  static Failure handleException(
    Exception exception, [
    StackTrace? stackTrace,
  ]) {
    if (exception is AppException) {
      final failure = _mapExceptionToFailure(exception, stackTrace);
      _reportIfBlocking(failure, exception, stackTrace);
      return failure;
    }

    if (exception is DioException) {
      return handleDioException(exception);
    }

    if (exception is SocketException) {
      final failure = NoInternetFailure(
        originalError: exception,
        stackTrace: stackTrace,
      );
      _reportIfBlocking(failure, exception, stackTrace);
      return failure;
    }

    if (exception is FormatException) {
      final failure = UnknownFailure(
        message: 'data_format_error'.tr(),
        code: 'FORMAT_ERROR',
      );
      _reportIfBlocking(failure, exception, stackTrace);
      return failure;
    }

    final failure = UnknownFailure(
      message: exception.toString(),
      originalError: exception,
      stackTrace: stackTrace,
    );
    _reportIfBlocking(failure, exception, stackTrace);
    return failure;
  }

  /// Map AppException to Failure
  static Failure _mapExceptionToFailure(
    AppException exception,
    StackTrace? stackTrace,
  ) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is UnauthorizedException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is ForbiddenException) {
      return PermissionFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is NotFoundException) {
      return NotFoundFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        errors: exception.errors,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is BadRequestException) {
      return BadRequestFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    return UnknownFailure(
      message: exception.message,
      code: exception.code,
      originalError: exception.originalError,
      stackTrace: stackTrace,
    );
  }

  /// Reports app-blocking failures to Crashlytics.
  /// Skips user-caused errors (validation, auth, permission, not-found,
  /// bad-request, cancel) since they are expected and don't indicate bugs.
  static void _reportIfBlocking(
    Failure failure,
    Object error,
    StackTrace? stackTrace,
  ) {
    final isBlocking = failure is ServerFailure ||
        failure is NetworkFailure ||
        failure is NoInternetFailure ||
        failure is TimeoutFailure ||
        failure is CacheFailure ||
        failure is UnknownFailure;

    if (!isBlocking) return;

    CrashlyticsService.log(
      '[${failure.runtimeType}] code=${failure.code} msg=${failure.message}',
    );
    CrashlyticsService.recordError(
      error,
      stackTrace ?? StackTrace.current,
      fatal: failure is ServerFailure,
    );
  }
}
