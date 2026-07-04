import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/quick_patient_model.dart';

abstract class ClinicDashboardMockDataSource {
  ApiResult<DashboardStatsModel> getStats();
  ApiResult<List<BookingRequestModel>> getPendingBookings();
  ApiResult<List<QuickPatientModel>> searchPatients(String query);
  ApiResult<bool> acceptBooking(int id);
  ApiResult<bool> rejectBooking(int id);
}

class ClinicDashboardMockDataSourceImpl
    implements ClinicDashboardMockDataSource {
  @override
  ApiResult<DashboardStatsModel> getStats() {
    return ApiResult.success(DashboardStatsModel.mock());
  }

  @override
  ApiResult<List<BookingRequestModel>> getPendingBookings() {
    return ApiResult.success(BookingRequestModel.mockList());
  }

  @override
  ApiResult<List<QuickPatientModel>> searchPatients(String query) {
    final all = QuickPatientModel.mockList();
    if (query.isEmpty) {
      return ApiResult.success(all);
    }
    final filtered = all.where((p) {
      final q = query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.phone.toLowerCase().contains(q);
    }).toList();
    return ApiResult.success(filtered);
  }

  @override
  ApiResult<bool> acceptBooking(int id) {
    return ApiResult.success(true);
  }

  @override
  ApiResult<bool> rejectBooking(int id) {
    return ApiResult.success(true);
  }
}
