import 'package:doctory/core/network/interfaces/api_result.dart';
import '../repositories/booking_repository.dart';
import '../../data/model/payment_dto.dart';

class VerifyPaymentUseCase {
  final BookingRepository repository;

  VerifyPaymentUseCase(this.repository);

  Future<ApiResult<PaymentResponseDto>> call({
    required String paymentId,
    required String transactionId,
  }) {
    return repository.verifyPayment(
      paymentId: paymentId,
      transactionId: transactionId,
    );
  }
}
