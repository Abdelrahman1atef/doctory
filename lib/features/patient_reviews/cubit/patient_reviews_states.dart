import 'package:doctory/core/common/models/shared_models.dart';

abstract class PatientReviewsStates {}

class PatientReviewsInitial extends PatientReviewsStates {}

class PatientReviewsLoading extends PatientReviewsStates {}

class PatientReviewsLoaded extends PatientReviewsStates {
  final List<ReviewModel> reviews;
  PatientReviewsLoaded(this.reviews);
}

class PatientReviewsError extends PatientReviewsStates {
  final String message;
  PatientReviewsError(this.message);
}
