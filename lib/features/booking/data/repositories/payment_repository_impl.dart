import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/booking_mock_data_source.dart';
import '../model/payment_dto.dart';

Failure _toFailure(Object error) {
  if (error is Exception) return ErrorHandler.handleException(error);
  return UnknownFailure(message: error.toString());
}

class PaymentRepositoryImpl implements PaymentRepository {
  final BookingMockDataSource mockDataSource;

  PaymentRepositoryImpl({required this.mockDataSource});

  @override
  Future<ApiResult<PaymentResponseDto>> processPayment(
    PaymentRequestDto request,
  ) async {
    try {
      final result = await mockDataSource.processPayment(request);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<PaymentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    try {
      final result = await mockDataSource.verifyPayment(
        paymentId: paymentId,
        transactionId: transactionId,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<PaymentResponseDto>> getPaymentStatus({
    required String paymentId,
  }) async {
    try {
      final result = await mockDataSource.verifyPayment(
        paymentId: paymentId,
        transactionId: '',
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }
}
