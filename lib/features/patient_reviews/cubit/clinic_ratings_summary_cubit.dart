import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/patient_reviews/cubit/clinic_ratings_summary_states.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_dto.dart';
import 'package:doctory/features/patient_reviews/data/repo/patient_reviews_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fetches the three clinic rating lists (clinic / reception / cleanliness)
/// and computes the average + count of each type for the summary section.
class ClinicRatingsSummaryCubit extends Cubit<ClinicRatingsSummaryStates> {
  ClinicRatingsSummaryCubit(this._repo) : super(ClinicRatingsSummaryInitial());

  final PatientReviewsRepo _repo;

  Future<void> loadSummary(String clinicId) async {
    emit(ClinicRatingsSummaryLoading());

    final results = await Future.wait([
      _repo.getClinicRatings(clinicId),
      _repo.getClinicReceptionRatings(clinicId),
      _repo.getClinicCleanlinessRatings(clinicId),
    ]);

    if (results.every((result) => result.isFailure)) {
      emit(ClinicRatingsSummaryError(results.first.failure!.userMessage));
      return;
    }

    emit(
      ClinicRatingsSummaryLoaded(
        clinicAverage: _average(results[0].data),
        clinicCount: results[0].data?.length ?? 0,
        receptionAverage: _average(results[1].data),
        receptionCount: results[1].data?.length ?? 0,
        cleanlinessAverage: _average(results[2].data),
        cleanlinessCount: results[2].data?.length ?? 0,
      ),
    );
  }

  double _average(List<RatingDto>? ratings) {
    if (ratings == null || ratings.isEmpty) return 0;
    return ratings.map((r) => r.value).reduce((a, b) => a + b) / ratings.length;
  }
}