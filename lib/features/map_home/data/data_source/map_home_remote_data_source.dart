import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/network/util/paginated_data.dart';
import 'package:doctory/features/map_home/data/data_source/map_home_endpoints.dart';
import 'package:doctory/features/map_home/data/model/map_home_models.dart';
import 'package:doctory/features/map_home/data/model/route_model.dart';
import 'package:flutter/foundation.dart';

RouteModel _parseRoute(Map<String, dynamic> json) => RouteModel.fromJson(json);

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
    dynamic cancelToken,
  });

  Future<ApiResult<RouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    dynamic cancelToken,
  });

  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecializations({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
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
    dynamic cancelToken,
  }) async {
    return await _apiConsumer.get(
      path: MapHomeEndpoints.searchClinics,
      queryParameters: {
        'SearchText': ?searchText,
        'SpecializationId': ?specializationId,
        'UserLat': ?userLat,
        'UserLng': ?userLng,
        'IsNearest': ?isNearest,
        'RadiusInKm': ?radiusInKm,
        'PageNumber': ?pageNumber,
        'PageSize': ?pageSize,
      },
      cancelToken: cancelToken,
      parser: (json) => ClinicSearchResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResult<RouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    dynamic cancelToken,
  }) async {
    // 1. Get raw JSON
    final rawResult = await _apiConsumer.get<Map<String, dynamic>>(
      path: MapHomeEndpoints.getRoute,
      queryParameters: {
        'StartLat': startLat,
        'StartLng': startLng,
        'EndLat': endLat,
        'EndLng': endLng,
      },
      cancelToken: cancelToken,
    );

    // 2. Map JSON to Model using compute (runs on background thread)
    return rawResult.fold(
      onSuccess: (data) async {
        try {
          final parsed = await compute(_parseRoute, data);
          return ApiResult.success(parsed);
        } catch (e) {
          return ApiResult.failure(
            UnknownFailure(message: 'Failed to parse route data'),
          );
        }
      },
      onFailure: (failure) async => ApiResult<RouteModel>.failure(failure),
    );
  }

  @override
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecializations({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
  }) async {
    return await _apiConsumer.get<PaginatedData<SpecialtyModel>>(
      path: 'specializations',
      queryParameters: {
        'PageNumber': ?pageNumber,
        'PageSize': ?pageSize,
        'IsFamous': ?isFamous,
      },
      parser:
          (json) => PaginatedData.fromJson(
            json['data'],
            (item) => SpecialtyModel.fromJson(item),
          ),
    );
  }
}
