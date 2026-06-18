import 'package:doctory/core/network/interfaces/api_result.dart';
import '../repositories/booking_repository.dart';
import '../../data/model/payment_dto.dart';

class ProcessPaymentUseCase {
  final BookingRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<ApiResult<PaymentResponseDto>> call(PaymentRequestDto request) {
    return repository.processPayment(request);
  }
}
