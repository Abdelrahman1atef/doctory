import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/booking/data/model/appointment_list_response_dto.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'my_appointments_endpoints.dart';

abstract class MyAppointmentsRemoteDataSource {
  Future<ApiResult<AppointmentListResponseDto>> getAppointments({
    int? pageNumber,
    int? pageSize,
    AppointmentStatus? status,
  });

  Future<ApiResult<AppointmentResponseDto>> getAppointmentById(String id);

  Future<ApiResult<void>> cancelAppointment({
    required String id,
    required String cancellationReason,
  });

  /// Creates the payment for an accepted appointment and returns the gateway
  /// payload, which carries the `redirectUrl` the webview opens.
  Future<ApiResult<Map<String, dynamic>>> initiatePayment({
    required String appointmentId,
    required String paymentMethod,
    required String returnUrl,
  });

  /// Confirms a payment with the server after the gateway returns, and yields
  /// the refreshed appointment.
  ///
  /// [transactionId] is optional: the gateway's return URL carries only the
  /// payment id, so it is omitted from the request when unknown.
  Future<ApiResult<AppointmentResponseDto>> verifyPayment({
    required String paymentId,
    String? transactionId,
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
    AppointmentStatus? status,
  }) async {
    return apiConsumer.get<AppointmentListResponseDto>(
      path: MyAppointmentsEndpoints.myAppointments,
      queryParameters: {
        if (pageNumber != null) 'PageNumber': pageNumber.toString(),
        if (pageSize != null) 'PageSize': pageSize.toString(),
        if (status != null) 'status': status.value,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> initiatePayment({
    required String appointmentId,
    required String paymentMethod,
    required String returnUrl,
  }) async {
    return apiConsumer.post<Map<String, dynamic>>(
      path: MyAppointmentsEndpoints.payments,
      body: {
        'reservationId': appointmentId,
        'paymentMethod': paymentMethod,
        'returnUrl': returnUrl,
      },
      parser: (json) => (json['data'] ?? json) as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> verifyPayment({
    required String paymentId,
    String? transactionId,
  }) async {
    return apiConsumer.post<AppointmentResponseDto>(
      path: MyAppointmentsEndpoints.verifyPayment,
      body: {
        'paymentId': paymentId,
        if (transactionId != null && transactionId.isNotEmpty)
          'transactionId': transactionId,
      },
      parser: (json) => AppointmentResponseDto.fromJson(json['data'] ?? json),
    );
  }
}
