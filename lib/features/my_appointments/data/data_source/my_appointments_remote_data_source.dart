import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/booking/data/model/appointment_list_response_dto.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/data/model/initiate_payment_response_dto.dart';
import 'my_appointments_endpoints.dart';

abstract class MyAppointmentsRemoteDataSource {
  Future<ApiResult<AppointmentListResponseDto>> getAppointments({
    int? pageNumber,
    int? pageSize,
    int? status,
  });

  Future<ApiResult<AppointmentResponseDto>> getAppointmentById(String id);

  Future<ApiResult<void>> cancelAppointment(String id);

  Future<ApiResult<InitiatePaymentResponseDto>> initiatePayment({
    required String appointmentId,
    required String phoneNumber,
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
      path: MyAppointmentsEndpoints.appointments,
      queryParameters: {
        if (pageNumber != null) 'PageNumber': pageNumber.toString(),
        if (pageSize != null) 'PageSize': pageSize.toString(),
        if (status != null) 'Status': status.toString(),
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
  Future<ApiResult<void>> cancelAppointment(String id) async {
    return apiConsumer.delete<void>(
      path: '${MyAppointmentsEndpoints.appointments}/$id',
    );
  }

  @override
  Future<ApiResult<InitiatePaymentResponseDto>> initiatePayment({
    required String appointmentId,
    required String phoneNumber,
  }) async {
    return apiConsumer.post<InitiatePaymentResponseDto>(
      path: 'payments/initiate',
      body: {
        'appointmentId': appointmentId,
        'phoneNumber': phoneNumber,
      },
      parser: (json) => InitiatePaymentResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }
}