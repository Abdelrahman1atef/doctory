import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_dto.dart';
import 'package:doctory/features/patient_reviews/data/model/submit_rating_request.dart';

abstract class PatientReviewsRemoteDataSource {
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

class PatientReviewsRemoteDataSourceImpl
    implements PatientReviewsRemoteDataSource {
  final ApiConsumer apiConsumer;

  PatientReviewsRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<ApiResult<RatingDto>> submitRating(SubmitRatingRequest request) async {
    return await apiConsumer.post<RatingDto>(
      path: 'ratings',
      body: request.toJson(),
      parser: (json) =>
          RatingDto.fromJson((json['data'] ?? json) as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<RatingDto>>> getDoctorRatings(String doctorId) async {
    return await _getRatingList('doctors/$doctorId/ratings');
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicRatings(String clinicId) async {
    return await _getRatingList('clinics/$clinicId/ratings');
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicCleanlinessRatings(
    String clinicId,
  ) async {
    return await _getRatingList(
      'clinics/$clinicId/place-cleanliness-ratings',
    );
  }

  @override
  Future<ApiResult<List<RatingDto>>> getClinicReceptionRatings(
    String clinicId,
  ) async {
    return await _getRatingList('clinics/$clinicId/reception-ratings');
  }

  Future<ApiResult<List<RatingDto>>> _getRatingList(String path) async {
    return await apiConsumer.get<List<RatingDto>>(
      path: path,
      parser: (json) {
        final data = json['data'] ?? json['Data'] ?? json;
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(RatingDto.fromJson)
              .toList();
        }
        return const [];
      },
    );
  }
}