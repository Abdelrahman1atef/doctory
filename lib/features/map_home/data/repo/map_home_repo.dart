import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/network/util/paginated_data.dart';
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
    dynamic cancelToken,
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
      cancelToken: cancelToken,
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
    return await _remoteDataSource.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecializations({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
  }) async {
    return await _remoteDataSource.getSpecializations(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isFamous: isFamous,
    );
  }
}
