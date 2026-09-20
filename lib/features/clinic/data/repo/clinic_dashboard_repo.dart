import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';

abstract class ClinicDashboardRepo {
  Future<ApiResult<DashboardStatsModel>> getStats();
  Future<ApiResult<PaginatedBookingsResponse>> getBookingsByStatus(String status, int page, int perPage);
  Future<ApiResult<bool>> acceptBooking(String id, {String? paymentMethod});
  Future<ApiResult<bool>> rejectBooking(String id);

  Future<ApiResult<BookingConfigDto>> getBookingConfig(String clinicId);
  Future<ApiResult<BookingConfigDto>> createBookingConfig(String clinicId, BookingConfigDto config);
  Future<ApiResult<BookingConfigDto>> updateBookingConfig(String clinicId, BookingConfigDto config);

  Future<ApiResult<List<AvailabilityDto>>> getAvailability(String doctorId, String clinicId);
  Future<ApiResult<AvailabilityDto>> createAvailability(AvailabilityDto availability);
  Future<ApiResult<AvailabilityDto>> updateAvailability(String id, AvailabilityDto availability);
  Future<ApiResult<void>> deleteAvailability(String id);
}
