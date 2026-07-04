import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_mock_data_source.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';

abstract class ReservationRequestsRepo {
  Future<ApiResult<List<BookingRequestModel>>> getPending();
  Future<ApiResult<bool>> accept(int requestId);
  Future<ApiResult<bool>> reject(int requestId);
}

class ReservationRequestsRepoImpl implements ReservationRequestsRepo {
  final ClinicDashboardMockDataSource _dataSource;

  ReservationRequestsRepoImpl(this._dataSource);

  @override
  Future<ApiResult<List<BookingRequestModel>>> getPending() async {
    try {
      return _dataSource.getPendingBookings();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> accept(int requestId) async {
    try {
      return _dataSource.acceptBooking(requestId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<bool>> reject(int requestId) async {
    try {
      return _dataSource.rejectBooking(requestId);
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
