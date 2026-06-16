import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/home/data/data_source/home_remote_data_source.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/network/util/paginated_data.dart';

abstract class HomeRepo {
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecialties({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
  });
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors();
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics();
}

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecialties({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
  }) async {
    try {
      return await _remoteDataSource.getSpecialties(
        pageNumber: pageNumber,
        pageSize: pageSize,
        isFamous: isFamous,
      );
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors() async {
    try {
      return await _remoteDataSource.getRecommendedDoctors();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics() async {
    try {
      return await _remoteDataSource.getFeaturedClinics();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
