import '../../../../core/network/interfaces/api_consumer.dart';
import '../model/booking_available_slots_model.dart';
import '../model/create_appointment_request.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResult<BookingAvailableSlotsModel>> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  });

  Future<ApiResult<dynamic>> createAppointment(CreateAppointmentRequest request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiConsumer apiConsumer;

  BookingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<BookingAvailableSlotsModel>> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  }) async {
    return await apiConsumer.get<BookingAvailableSlotsModel>(
      path: 'appointments/available-slots',
      queryParameters: {
        'DoctorId': doctorId,
        'ClinicId': clinicId,
        'Date': DateFormat('yyyy-MM-dd').format(date),
      },
      parser: (json) {
        if (json.containsKey('data')) {
          return BookingAvailableSlotsModel.fromJson(json['data']);
        }
        return BookingAvailableSlotsModel.fromJson(json);
      },
    );
  }

  @override
  Future<ApiResult<dynamic>> createAppointment(CreateAppointmentRequest request) async {
    return await apiConsumer.post<dynamic>(
      path: 'appointments',
      body: request.toJson(),
      parser: (json) => json['data'] ?? json,
    );
  }
}
