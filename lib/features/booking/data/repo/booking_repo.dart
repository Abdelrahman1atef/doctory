import '../../../../../core/network/interfaces/api_result.dart';
import '../data_source/booking_remote_data_source.dart';
import '../model/booking_available_slots_model.dart';
import '../model/create_appointment_request.dart';

abstract class BookingRepo {
  Future<ApiResult<BookingAvailableSlotsModel>> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  });

  Future<ApiResult<dynamic>> createAppointment(CreateAppointmentRequest request);
}

class BookingRepoImpl implements BookingRepo {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepoImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<BookingAvailableSlotsModel>> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  }) async {
    return await remoteDataSource.getAvailableSlots(
      doctorId: doctorId,
      clinicId: clinicId,
      date: date,
    );
  }

  @override
  Future<ApiResult<dynamic>> createAppointment(CreateAppointmentRequest request) async {
    return await remoteDataSource.createAppointment(request);
  }
}
