import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/network/util/paginated_data.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecialties({
    int? pageNumber,
    int? pageSize,
    bool? isFamous,
  });
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors();
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  HomeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<PaginatedData<SpecialtyModel>>> getSpecialties({
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
      parser: (json) => PaginatedData.fromJson(
        json['data'],
        (item) => SpecialtyModel.fromJson(item),
      ),
    );
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors() async {
    return ApiResult.success([]);
  }

  @override
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics() async {
    return ApiResult.success([]);
  }
}
