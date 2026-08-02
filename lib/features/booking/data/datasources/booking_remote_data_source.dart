import 'package:doctory/core/network/interfaces/api_consumer.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/appointment_response_dto.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResult<AppointmentResponseDto>> createAppointment(
    CreateAppointmentRequestDto request,
  );

  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiConsumer apiConsumer;

  BookingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<AppointmentResponseDto>> createAppointment(
    CreateAppointmentRequestDto request,
  ) async {
    return apiConsumer.post<AppointmentResponseDto>(
      path: 'appointments',
      body: request.toJson(),
      parser: (json) => AppointmentResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  }) async {
    return apiConsumer.get<AppointmentResponseDto>(
      path: 'appointments/$appointmentId',
      parser: (json) => AppointmentResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }
}
