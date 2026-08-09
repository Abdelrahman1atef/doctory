import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_states.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_dto.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_target.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_type.dart';
import 'package:doctory/features/patient_reviews/data/model/submit_rating_request.dart';
import 'package:doctory/features/patient_reviews/data/repo/patient_reviews_repo.dart';

class PatientReviewsCubit extends Cubit<PatientReviewsStates> {
  PatientReviewsCubit(this._repo) : super(PatientReviewsInitial());

  final PatientReviewsRepo _repo;

  Future<void> loadReviews(RatingTarget target) async {
    emit(PatientReviewsLoading());
    await _fetchAndEmit(target);
  }

  /// Reloads the list without flashing a loading state when data already
  /// exists, and without overriding the current list on failure.
  Future<void> refreshReviews(RatingTarget target) async {
    await _fetchAndEmit(target, silent: state is PatientReviewsLoaded);
  }

  Future<void> _fetchAndEmit(
    RatingTarget target, {
    bool silent = false,
  }) async {
    final result = await switch (target.entityType) {
      RatingEntityType.doctor => _repo.getDoctorRatings(target.entityId),
      RatingEntityType.clinic => _loadClinicRatings(target.entityId),
    };
    result.fold(
      onSuccess: (ratings) => emit(
        PatientReviewsLoaded(
          ratings.map(_toReviewModel).toList(),
          _alreadyRatedTypes(ratings),
        ),
      ),
      onFailure: (failure) {
        if (!silent) emit(PatientReviewsError(failure.userMessage));
      },
    );
  }

  /// Merges clinic (type 2) and cleanliness (type 3) rating lists.
  Future<ApiResult<List<RatingDto>>> _loadClinicRatings(
    String clinicId,
  ) async {
    final clinicResult = await _repo.getClinicRatings(clinicId);
    final cleanlinessResult =
        await _repo.getClinicCleanlinessRatings(clinicId);

    if (clinicResult.isFailure && cleanlinessResult.isFailure) {
      return ApiResult.failure(
        clinicResult.failure ?? cleanlinessResult.failure!,
      );
    }

    final merged = <RatingDto>[
      ...?clinicResult.data,
      ...?cleanlinessResult.data,
    ];
    final seen = <String>{};
    return ApiResult.success(merged.where((r) => seen.add(r.id)).toList());
  }

  Future<RatingSubmitOutcome> submitSection({
    required RatingType type,
    String? doctorId,
    String? clinicId,
    required int value,
    String? review,
  }) async {
    final request = SubmitRatingRequest(
      type: type,
      doctorId: doctorId,
      clinicId: clinicId,
      value: value.clamp(1, 5),
      review: review,
    );

    final result = await _repo.submitRating(request);
    return result.fold(
      onSuccess: (_) => const RatingSubmitOutcome(RatingSubmitResult.success),
      onFailure: (failure) {
        if (failure is BadRequestFailure) {
          return RatingSubmitOutcome(RatingSubmitResult.alreadyRated, failure.message);
        }
        return RatingSubmitOutcome(RatingSubmitResult.failed, failure.userMessage);
      },
    );
  }

  /// Sections the current user already rated, derived from the ratings list.
  Set<RatingType> _alreadyRatedTypes(List<RatingDto> ratings) {
    final userId = UserSession.userId;
    if (userId == null || userId.isEmpty) return {};
    return ratings
        .where((r) => r.userId == userId)
        .map((r) => RatingType.values.firstWhere(
              (t) => t.value == r.type,
              orElse: () => RatingType.clinic,
            ))
        .toSet();
  }

  ReviewModel _toReviewModel(RatingDto dto) {
    return ReviewModel(
      id: dto.id,
      userId: dto.userId,
      patientName: dto.userName ?? '',
      rating: dto.value.toDouble(),
      comment: dto.review ?? '',
      date: DateTime.tryParse(dto.createdAt ?? '') ?? DateTime.now(),
      type: dto.type,
    );
  }
}