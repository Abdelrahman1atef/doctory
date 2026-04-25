import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/search_results/data/data_source/search_remote_data_source.dart';
import 'package:doctory/features/search_results/data/model/hospital_model.dart';

abstract class SearchRepo {
  Future<ApiResult<List<HospitalModel>>> searchHospitals({
    required double lat,
    required double lng,
    String? query,
  });
}

class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<HospitalModel>>> searchHospitals({
    required double lat,
    required double lng,
    String? query,
  }) async {
    try {
      return await _remoteDataSource.searchHospitals(
        lat: lat,
        lng: lng,
        query: query,
      );
    } catch (e) {
      return ApiResult.failure(UnknownFailure(message: e.toString()));
    }
  }
}
