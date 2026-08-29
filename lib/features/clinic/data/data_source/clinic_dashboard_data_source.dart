import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';

abstract class ClinicDashboardDataSource {
  Future<ApiResult<DashboardStatsModel>> getStats();
  Future<ApiResult<List<BookingRequestModel>>> getBookingsByStatus(String status, int page, int perPage);
  Future<ApiResult<bool>> acceptBooking(String id, {String? paymentMethod});
  Future<ApiResult<bool>> rejectBooking(String id);
}
