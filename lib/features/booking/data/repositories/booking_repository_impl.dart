import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/initiate_payment_response_dto.dart';
import '../model/payment_dto.dart';
import '../model/appointment_response_dto.dart';
import '../model/booking_config_dto.dart';

Failure _toFailure(Object error) {
  if (error is Exception) return ErrorHandler.handleException(error);
  return UnknownFailure(message: error.toString());
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<CreateReservationResponseDto>> createReservation(
    CreateAppointmentRequestDto request,
  ) async {
    try {
      return await remoteDataSource.createReservation(request);
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
      return await remoteDataSource.confirmAppointment(
        reservationId: reservationId,
        patientId: patientId,
      );
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<PaymentResponseDto>> processPayment(PaymentRequestDto request) async {
    try {
      return await remoteDataSource.processPayment(request);
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
      return await remoteDataSource.verifyPayment(
        paymentId: paymentId,
        transactionId: transactionId,
      );
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> getAppointment({required String appointmentId}) async {
    try {
      return await remoteDataSource.getAppointment(appointmentId: appointmentId);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<BookingConfigDto>> getBookingConfig({required String clinicId}) async {
    try {
      return await remoteDataSource.getBookingConfig(clinicId: clinicId);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<InitiatePaymentResponseDto>> initiatePayment({
    required String appointmentId,
    required String phoneNumber,
  }) async {
    try {
      return await remoteDataSource.initiatePayment(
        appointmentId: appointmentId,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }
}
