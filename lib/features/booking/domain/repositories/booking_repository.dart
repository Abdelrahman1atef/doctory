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

  /// [walletPhoneNumber] is required by the gateway for wallet payments and
  /// omitted from the request otherwise.
  Future<ApiResult<Map<String, dynamic>>> initiateBookingPayment({
    required String reservationId,
    required String paymentMethod,
    required String returnUrl,
    String? walletPhoneNumber,
  });

  Future<ApiResult<AppointmentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  });
}
