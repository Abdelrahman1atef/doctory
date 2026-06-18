import 'package:doctory/core/network/interfaces/api_result.dart';
import '../repositories/booking_repository.dart';
import '../../data/model/available_slots_dto.dart';

class GetAvailableSlotsUseCase {
  final BookingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<ApiResult<AvailableSlotsDto>> call({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  }) {
    return repository.getAvailableSlots(
      doctorId: doctorId,
      clinicId: clinicId,
      date: date,
    );
  }
}
