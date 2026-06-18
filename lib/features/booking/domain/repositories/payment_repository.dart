import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../data/model/payment_dto.dart';

abstract class PaymentRepository {
  Future<ApiResult<PaymentResponseDto>> processPayment(
    PaymentRequestDto request,
  );

  Future<ApiResult<PaymentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  });

  Future<ApiResult<PaymentResponseDto>> getPaymentStatus({
    required String paymentId,
  });
}
