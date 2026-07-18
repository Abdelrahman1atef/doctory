import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_data_source.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';

abstract class ReservationRequestsRepo {
  Future<ApiResult<List<BookingRequestModel>>> getPending(int page, int perPage);
  Future<ApiResult<bool>> accept(String requestId);
  Future<ApiResult<bool>> reject(String requestId);
}

class ReservationRequestsRepoImpl implements ReservationRequestsRepo {
  final ClinicDashboardDataSource _dataSource;

  ReservationRequestsRepoImpl(this._dataSource);

  @override
  Future<ApiResult<List<BookingRequestModel>>> getPending(int page, int perPage) async {
    try {
      return _dataSource.getBookingsByStatus('pending', page, perPage);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> accept(String requestId) async {
    try {
      return _dataSource.acceptBooking(requestId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> reject(String requestId) async {
    try {
      return _dataSource.rejectBooking(requestId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
