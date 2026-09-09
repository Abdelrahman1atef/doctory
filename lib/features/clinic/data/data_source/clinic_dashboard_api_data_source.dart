import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_data_source.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_endpoints.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';

class ClinicDashboardApiDataSource implements ClinicDashboardDataSource {
  final ApiConsumer _api;

  ClinicDashboardApiDataSource(this._api);

  @override
  Future<ApiResult<DashboardStatsModel>> getStats() async {
    return _api.get<DashboardStatsModel>(
      path: ClinicDashboardEndpoints.stats,
      parser: (json) => DashboardStatsModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<BookingRequestModel>>> getBookingsByStatus(
    String status,
    int page,
    int perPage,
  ) async {
    return _api.get<List<BookingRequestModel>>(
      path: ClinicDashboardEndpoints.bookings,
      queryParameters: {
        'status': status,
        'pageNumber': page,
        'pageSize': perPage,
      },
      parser: (json) {
        final paginated = PaginatedBookingsResponse.fromJson(json['data'] as Map<String, dynamic>);
        return paginated.items;
      },
    );
  }

  @override
  Future<ApiResult<bool>> acceptBooking(String id, {String? paymentMethod}) async {
    return _api.put<bool>(
      path: ClinicDashboardEndpoints.acceptBooking.replaceAll('{id}', id),
      queryParameters: {
        'paymentMethod': ?paymentMethod,
        'returnUrl': 'myapp://payment-result', // Placeholder
      },
      parser: (json) => json['data'] != null,
    );
  }

  @override
  Future<ApiResult<bool>> rejectBooking(String id) async {
    return _api.put<bool>(
      path: ClinicDashboardEndpoints.rejectBooking.replaceAll('{id}', id),
      parser: (json) => json['data'] != null,
    );
  }
}
