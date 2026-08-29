import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/appointment_response_dto.dart';

Failure _toFailure(Object error) {
  if (error is Exception) return ErrorHandler.handleException(error);
  return UnknownFailure(message: error.toString());
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<AppointmentResponseDto>> createAppointment(
    CreateAppointmentRequestDto request,
  ) async {
    try {
      return await remoteDataSource.createAppointment(request);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> getAppointment({
    required String appointmentId,
  }) async {
    try {
      return await remoteDataSource.getAppointment(appointmentId: appointmentId);
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> initiateBookingPayment({
    required String reservationId,
    required String paymentMethod,
    required String returnUrl,
  }) async {
    try {
      return await remoteDataSource.initiateBookingPayment(
        reservationId: reservationId,
        paymentMethod: paymentMethod,
        returnUrl: returnUrl,
      );
    } catch (e) {
      return ApiResult.failure(_toFailure(e));
    }
  }

  @override
  Future<ApiResult<AppointmentResponseDto>> verifyPayment({
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
}
