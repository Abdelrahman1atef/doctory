import 'package:doctory/core/network/interfaces/api_consumer.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/initiate_payment_response_dto.dart';
import '../model/payment_dto.dart';
import '../model/appointment_response_dto.dart';
import '../model/booking_config_dto.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResult<CreateReservationResponseDto>> createReservation(
    CreateAppointmentRequestDto request,
  );

  Future<ApiResult<AppointmentResponseDto>> confirmAppointment({
    required String reservationId,
    required String patientId,
  });

  Future<ApiResult<PaymentResponseDto>> processPayment(
    PaymentRequestDto request,
  );

  Future<ApiResult<PaymentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  });

  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  });

  Future<ApiResult<BookingConfigDto>> getBookingConfig({
    required String clinicId,
  });

  Future<ApiResult<InitiatePaymentResponseDto>> initiatePayment({
    required String appointmentId,
    required String phoneNumber,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiConsumer apiConsumer;

  BookingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<CreateReservationResponseDto>> createReservation(
    CreateAppointmentRequestDto request,
  ) async {
    return apiConsumer.post<CreateReservationResponseDto>(
      path: 'reservations',
      body: request.toJson(),
      parser: (json) => CreateReservationResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> confirmAppointment({
    required String reservationId,
    required String patientId,
  }) async {
    return apiConsumer.post<AppointmentResponseDto>(
      path: 'appointments/confirm',
      body: {
        'reservationId': reservationId,
        'patientId': patientId,
      },
      parser: (json) => AppointmentResponseDto.fromJson(
        json['data'] ?? json,
      ),
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

  @override
  Future<ApiResult<PaymentResponseDto>> processPayment(
    PaymentRequestDto request,
  ) async {
    return apiConsumer.post<PaymentResponseDto>(
      path: 'payments',
      body: request.toJson(),
      parser: (json) => PaymentResponseDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }

  @override
  Future<ApiResult<PaymentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    return apiConsumer.post<PaymentResponseDto>(
      path: 'payments/verify',
      body: {
        'paymentId': paymentId,
        'transactionId': transactionId,
      },
      parser: (json) => PaymentResponseDto.fromJson(
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

  @override
  Future<ApiResult<BookingConfigDto>> getBookingConfig({
    required String clinicId,
  }) async {
    return apiConsumer.get<BookingConfigDto>(
      path: 'clinics/$clinicId/booking-config',
      parser: (json) => BookingConfigDto.fromJson(
        json['data'] ?? json,
      ),
    );
  }
}
