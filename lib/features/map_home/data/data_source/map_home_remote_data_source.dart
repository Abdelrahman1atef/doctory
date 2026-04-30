import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/map_home/data/data_source/map_home_endpoints.dart';
import 'package:doctory/features/map_home/data/model/map_home_models.dart';
import 'package:doctory/features/map_home/data/model/route_model.dart';

abstract class MapHomeRemoteDataSource {
  Future<ApiResult<ClinicSearchResponse>> searchClinics({
    String? searchText,
    String? specializationId,
    double? userLat,
    double? userLng,
    bool? isNearest,
    int? radiusInKm,
    int? pageNumber,
    int? pageSize,
  });

  Future<ApiResult<RouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
}

class MapHomeRemoteDataSourceImpl implements MapHomeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  MapHomeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<ClinicSearchResponse>> searchClinics({
    String? searchText,
    String? specializationId,
    double? userLat,
    double? userLng,
    bool? isNearest,
    int? radiusInKm,
    int? pageNumber,
    int? pageSize,
  }) async {
    return await _apiConsumer.get(
      path: MapHomeEndpoints.searchClinics,
      queryParameters: {
        if (searchText != null) 'SearchText': searchText,
        if (specializationId != null) 'SpecializationId': specializationId,
        if (userLat != null) 'UserLat': userLat,
        if (userLng != null) 'UserLng': userLng,
        if (isNearest != null) 'IsNearest': isNearest,
        if (radiusInKm != null) 'RadiusInKm': radiusInKm,
        if (pageNumber != null) 'PageNumber': pageNumber,
        if (pageSize != null) 'PageSize': pageSize,
      },
      parser: (json) => ClinicSearchResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<RouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    return await _apiConsumer.get(
      path: MapHomeEndpoints.getRoute,
      queryParameters: {
        'StartLat': startLat,
        'StartLng': startLng,
        'EndLat': endLat,
        'EndLng': endLng,
      },
      parser: (json) => RouteModel.fromJson(json),
    );
  }
}
