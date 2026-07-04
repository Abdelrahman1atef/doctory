import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic_dashboard/data/data_source/clinic_dashboard_mock_data_source.dart';
import 'package:doctory/features/clinic_dashboard/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic_dashboard/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic_dashboard/data/model/quick_patient_model.dart';
import 'package:doctory/features/clinic_dashboard/data/repo/clinic_dashboard_repo.dart';

class ClinicDashboardRepoImpl implements ClinicDashboardRepo {
  final ClinicDashboardMockDataSource _dataSource;

  ClinicDashboardRepoImpl(this._dataSource);

  @override
  Future<ApiResult<DashboardStatsModel>> getStats() async {
    try {
      return _dataSource.getStats();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<List<BookingRequestModel>>> getPendingBookings() async {
    try {
      return _dataSource.getPendingBookings();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<List<QuickPatientModel>>> searchPatients(String query) async {
    try {
      return _dataSource.searchPatients(query);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> acceptBooking(int id) async {
    try {
      return _dataSource.acceptBooking(id);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> rejectBooking(int id) async {
    try {
      return _dataSource.rejectBooking(id);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
