import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/booking/data/model/appointment_list_response_dto.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'my_appointments_endpoints.dart';

abstract class MyAppointmentsRemoteDataSource {
  Future<ApiResult<AppointmentListResponseDto>> getAppointments({
    int? pageNumber,
    int? pageSize,
    int? status,
  });

  Future<ApiResult<AppointmentResponseDto>> getAppointmentById(String id);

  Future<ApiResult<void>> cancelAppointment({
    required String id,
    required String cancellationReason,
  });
}

class MyAppointmentsRemoteDataSourceImpl
    implements MyAppointmentsRemoteDataSource {
  final ApiConsumer apiConsumer;

  MyAppointmentsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<AppointmentListResponseDto>> getAppointments({
    int? pageNumber,
    int? pageSize,
    int? status,
  }) async {
    return apiConsumer.get<AppointmentListResponseDto>(
      path: MyAppointmentsEndpoints.myAppointments,
      queryParameters: {
        if (pageNumber != null) 'PageNumber': pageNumber.toString(),
        if (pageSize != null) 'PageSize': pageSize.toString(),
        if (status != null) 'status': status.toString(),
      },
      parser: (json) => AppointmentListResponseDto.fromJson(json),
    );
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> getAppointmentById(String id) async {
    return apiConsumer.get<AppointmentResponseDto>(
      path: '${MyAppointmentsEndpoints.appointments}/$id',
      parser: (json) => AppointmentResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }

  @override
  Future<ApiResult<void>> cancelAppointment({
    required String id,
    required String cancellationReason,
  }) async {
    return apiConsumer.put<void>(
      path: '${MyAppointmentsEndpoints.appointments}/$id/cancel',
      body: {
        'cancellationReason': cancellationReason,
      },
    );
  }
}
