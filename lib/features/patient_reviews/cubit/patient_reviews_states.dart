import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_type.dart';

abstract class PatientReviewsStates {}

class PatientReviewsInitial extends PatientReviewsStates {}

class PatientReviewsLoading extends PatientReviewsStates {}

class PatientReviewsLoaded extends PatientReviewsStates {
  final List<ReviewModel> reviews;

  /// Rating types the current user has already submitted (pre-locks sections).
  final Set<RatingType> alreadyRatedTypes;

  PatientReviewsLoaded(this.reviews, this.alreadyRatedTypes);
}

class PatientReviewsError extends PatientReviewsStates {
  final String message;
  PatientReviewsError(this.message);
}

/// Outcome of a single rating-section submission.
enum RatingSubmitResult {
  success,
  alreadyRated,
  failed,
}

/// Submission outcome plus a display message (server or localized).
class RatingSubmitOutcome {
  final RatingSubmitResult result;
  final String? message;

  const RatingSubmitOutcome(this.result, [this.message]);
}