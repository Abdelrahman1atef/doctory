import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/patient_reviews/data/data_source/patient_reviews_remote_data_source.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_dto.dart';
import 'package:doctory/features/patient_reviews/data/model/submit_rating_request.dart';

abstract class PatientReviewsRepo {
  Future<ApiResult<RatingDto>> submitRating(SubmitRatingRequest request);

  Future<ApiResult<List<RatingDto>>> getDoctorRatings(String doctorId);

  Future<ApiResult<List<RatingDto>>> getClinicRatings(String clinicId);

  Future<ApiResult<List<RatingDto>>> getClinicCleanlinessRatings(
    String clinicId,
  );

  Future<ApiResult<List<RatingDto>>> getClinicReceptionRatings(
    String clinicId,
  );
}

class PatientReviewsRepoImpl implements PatientReviewsRepo {
  final PatientReviewsRemoteDataSource _dataSource;

  PatientReviewsRepoImpl(this._dataSource);

  @override
  Future<ApiResult<RatingDto>> submitRating(SubmitRatingRequest request) {
    return _dataSource.submitRating(request);
  }

  @override
  Future<ApiResult<List<RatingDto>>> getDoctorRatings(String doctorId) {
    return _dataSource.getDoctorRatings(doctorId);
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicRatings(String clinicId) {
    return _dataSource.getClinicRatings(clinicId);
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicCleanlinessRatings(
    String clinicId,
  ) {
    return _dataSource.getClinicCleanlinessRatings(clinicId);
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicReceptionRatings(
    String clinicId,
  ) {
    return _dataSource.getClinicReceptionRatings(clinicId);
  }
}