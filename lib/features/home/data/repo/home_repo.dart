import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/home/data/data_source/home_remote_data_source.dart';
import 'package:doctory/features/home/data/model/clinic_model.dart';
import 'package:doctory/features/home/data/model/doctor_model.dart';
import 'package:doctory/features/home/data/model/specialty_model.dart';

abstract class HomeRepo {
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties();
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors();
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics();
}

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties() async {
    try {
      return await _remoteDataSource.getSpecialties();
    } catch (e) {
      return ApiResult.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<DoctorModel>>> getRecommendedDoctors() async {
    try {
      return await _remoteDataSource.getRecommendedDoctors();
    } catch (e) {
      return ApiResult.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<ClinicModel>>> getFeaturedClinics() async {
    try {
      return await _remoteDataSource.getFeaturedClinics();
    } catch (e) {
      return ApiResult.failure(UnknownFailure(message: e.toString()));
    }
  }
}
