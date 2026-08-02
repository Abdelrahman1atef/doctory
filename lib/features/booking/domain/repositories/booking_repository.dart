import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../data/model/create_appointment_request_dto.dart';
import '../../data/model/appointment_response_dto.dart';

abstract class BookingRepository {
  Future<ApiResult<AppointmentResponseDto>> createAppointment(
    CreateAppointmentRequestDto request,
  );

  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  });
}
