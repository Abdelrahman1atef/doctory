import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_data_source.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';

class ClinicDashboardRepoImpl implements ClinicDashboardRepo {
  final ClinicDashboardDataSource _dataSource;

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
  Future<ApiResult<PaginatedBookingsResponse>> getBookingsByStatus(
      String status, int page, int perPage) async {
    try {
      return _dataSource.getBookingsByStatus(status, page, perPage);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> acceptBooking(String id, {String? paymentMethod}) async {
    try {
      return _dataSource.acceptBooking(id, paymentMethod: paymentMethod);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> rejectBooking(String id) async {
    try {
      return _dataSource.rejectBooking(id);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
