import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_data_source.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_endpoints.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';

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
  Future<ApiResult<PaginatedBookingsResponse>> getBookingsByStatus(
    String status,
    int page,
    int perPage,
  ) async {
    return _api.get<PaginatedBookingsResponse>(
      path: ClinicDashboardEndpoints.bookings,
      queryParameters: {
        'status': status,
        'pageNumber': page,
        'pageSize': perPage,
      },
      parser: (json) {
        return PaginatedBookingsResponse.fromJson(json['data'] as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<ApiResult<bool>> acceptBooking(String id, {String? paymentMethod}) async {
    return _api.put<bool>(
      path: ClinicDashboardEndpoints.acceptBooking.replaceAll('{id}', id),
      queryParameters: {
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
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

  @override
  Future<ApiResult<BookingConfigDto>> getBookingConfig(String clinicId) async {
    return _api.get<BookingConfigDto>(
      path: ClinicDashboardEndpoints.bookingConfig(clinicId),
      parser: (json) => BookingConfigDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<BookingConfigDto>> createBookingConfig(String clinicId, BookingConfigDto config) async {
    return _api.post<BookingConfigDto>(
      path: ClinicDashboardEndpoints.bookingConfig(clinicId),
      body: config.toJson(),
      parser: (json) => BookingConfigDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<BookingConfigDto>> updateBookingConfig(String clinicId, BookingConfigDto config) async {
    return _api.put<BookingConfigDto>(
      path: ClinicDashboardEndpoints.bookingConfig(clinicId),
      body: config.toJson(),
      parser: (json) => BookingConfigDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<AvailabilityDto>>> getAvailability(String doctorId, String clinicId) async {
    return _api.get<List<AvailabilityDto>>(
      path: ClinicDashboardEndpoints.availability,
      queryParameters: {
        'doctorId': doctorId,
        'clinicId': clinicId,
      },
      parser: (json) => (json['data'] as List).map((e) => AvailabilityDto.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResult<AvailabilityDto>> createAvailability(AvailabilityDto availability) async {
    return _api.post<AvailabilityDto>(
      path: ClinicDashboardEndpoints.availability,
      body: availability.toJson(),
      parser: (json) => AvailabilityDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<AvailabilityDto>> updateAvailability(String id, AvailabilityDto availability) async {
    return _api.put<AvailabilityDto>(
      path: ClinicDashboardEndpoints.updateAvailability(id),
      body: availability.toJson(),
      parser: (json) => AvailabilityDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> deleteAvailability(String id) async {
    return _api.delete<void>(
      path: ClinicDashboardEndpoints.deleteAvailability(id),
      parser: (_) {},
    );
  }
}
