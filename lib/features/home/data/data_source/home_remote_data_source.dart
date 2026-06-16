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
        if (pageNumber != null) 'PageNumber': pageNumber,
        if (pageSize != null) 'PageSize': pageSize,
        if (isFamous != null) 'IsFamous': isFamous,
      },
      parser:
          (json) => PaginatedData.fromJson(
            json['data'],
            (item) => SpecialtyModel.fromJson(item),
          ),
    );
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors() async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiResult.success([]);
    return ApiResult.success([
      DoctorModel(
        id: '1',
        name: 'د. سارة الأحمد',
        specialty: 'استشاري طب أسنان',
        nextAppointment: 'غداً، 10:00 ص',
        rating: 4.8,
        reviewsCount: 120,
      ),
      DoctorModel(
        id: '2',
        name: 'د. محمد علي',
        specialty: 'أخصائي أطفال',
        nextAppointment: 'اليوم، 05:00 م',
        rating: 4.5,
        reviewsCount: 85,
      ),
    ]);
  }

  @override
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics() async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiResult.success([]);
    return ApiResult.success([
      ClinicModel(
        id: '1',
        name: 'مجمع النور الطبي',
        description:
            'مركز طبي متكامل يضم نخبة من الاستشاريين في مختلف التخصصات بأحدث الأجهزة الطبية.',
        rating: 4.9,
      ),
      ClinicModel(
        id: '2',
        name: 'عيادات الحياة',
        description: 'رعاية صحية متميزة لعائلتك.',
        rating: 4.7,
      ),
    ]);
  }
}
