import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/map_home/data/data_source/map_home_remote_data_source.dart';
import 'package:doctory/features/map_home/data/model/map_home_models.dart';
import 'package:doctory/features/map_home/data/model/route_model.dart';

abstract class MapHomeRepo {
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

class MapHomeRepoImpl implements MapHomeRepo {
  final MapHomeRemoteDataSource _remoteDataSource;

  MapHomeRepoImpl(this._remoteDataSource);

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
    return await _remoteDataSource.searchClinics(
      searchText: searchText,
      specializationId: specializationId,
      userLat: userLat,
      userLng: userLng,
      isNearest: isNearest,
      radiusInKm: radiusInKm,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<ApiResult<RouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    return await _remoteDataSource.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
  }
}
