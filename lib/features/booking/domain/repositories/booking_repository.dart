import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../data/model/create_appointment_request_dto.dart';
import '../../data/model/initiate_payment_response_dto.dart';
import '../../data/model/payment_dto.dart';
import '../../data/model/appointment_response_dto.dart';
import '../../data/model/booking_config_dto.dart';

abstract class BookingRepository {
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
