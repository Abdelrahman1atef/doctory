import 'package:doctory/core/network/interfaces/api_result.dart';
import '../repositories/booking_repository.dart';
import '../../data/model/create_appointment_request_dto.dart';

class CreateReservationUseCase {
  final BookingRepository repository;

  CreateReservationUseCase(this.repository);

  Future<ApiResult<CreateReservationResponseDto>> call(
    CreateAppointmentRequestDto request,
  ) {
    return repository.createReservation(request);
  }
}
