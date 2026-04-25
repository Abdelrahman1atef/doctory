import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/common/models/shared_models.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties();
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors();
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // Using dummy data since endpoints are not ready yet

  @override
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties() async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiResult.success([
      SpecialtyModel(
        id: '1',
        name: 'أسنان',
        iconAsset: 'assets/icons/tooth.svg',
      ),
      SpecialtyModel(id: '2', name: 'قلب', iconAsset: 'assets/icons/heart.svg'),
      SpecialtyModel(id: '3', name: 'عيون', iconAsset: 'assets/icons/eye.svg'),
      SpecialtyModel(
        id: '4',
        name: 'باطنة',
        iconAsset: 'assets/icons/stomach.svg',
      ),
    ]);
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors() async {
    await Future.delayed(const Duration(seconds: 1));
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
