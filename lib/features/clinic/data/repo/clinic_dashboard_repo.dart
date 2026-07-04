import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/quick_patient_model.dart';

abstract class ClinicDashboardRepo {
  Future<ApiResult<DashboardStatsModel>> getStats();
  Future<ApiResult<List<BookingRequestModel>>> getPendingBookings();
  Future<ApiResult<List<QuickPatientModel>>> searchPatients(String query);
  Future<ApiResult<bool>> acceptBooking(int id);
  Future<ApiResult<bool>> rejectBooking(int id);
}
