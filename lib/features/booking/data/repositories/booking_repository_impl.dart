import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_mock_data_source.dart';
import '../model/available_slots_dto.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/payment_dto.dart';
import '../model/appointment_response_dto.dart';
import '../model/booking_config_dto.dart';

Failure _toFailure(Object error) {
  if (error is Exception) return ErrorHandler.handleException(error);
  return UnknownFailure(message: error.toString());
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingMockDataSource mockDataSource;

  BookingRepositoryImpl({required this.mockDataSource});

  @override
  Future<ApiResult<AvailableSlotsDto>> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  }) async {
    try {
      final result = await mockDataSource.getAvailableSlots(
        doctorId: doctorId,
        clinicId: clinicId,
        date: date,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<CreateReservationResponseDto>> createReservation(
    CreateAppointmentRequestDto request,
  ) async {
    try {
      final result = await mockDataSource.createReservation(request);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> confirmAppointment({
    required String reservationId,
    required String patientId,
  }) async {
    try {
      final result = await mockDataSource.confirmAppointment(
        reservationId: reservationId,
        patientId: patientId,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<PaymentResponseDto>> processPayment(
    PaymentRequestDto request,
  ) async {
    try {
      final result = await mockDataSource.processPayment(request);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<PaymentResponseDto>> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    try {
      final result = await mockDataSource.verifyPayment(
        paymentId: paymentId,
        transactionId: transactionId,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  }) async {
    try {
      final result = await mockDataSource.getAppointment(
        appointmentId: appointmentId,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<BookingConfigDto>> getBookingConfig({
    required String clinicId,
  }) async {
    try {
      final result = await mockDataSource.getBookingConfig(clinicId: clinicId);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }
}
