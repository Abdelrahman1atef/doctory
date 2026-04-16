import 'dart:async';
import 'package:dio/dio.dart';

/// Interceptor to handle 401 Unauthorized errors
class AuthInterceptor extends Interceptor {
  final StreamController<void> _unauthorizedController =
      StreamController<void>.broadcast();

  /// Stream of unauthorized events
  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _unauthorizedController.add(null);
    }
    super.onError(err, handler);
  }

  void dispose() {
    _unauthorizedController.close();
  }
}
