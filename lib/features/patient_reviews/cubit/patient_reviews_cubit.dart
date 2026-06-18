import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/patient_reviews/data/data_source/patient_reviews_mock_data.dart';
import 'patient_reviews_states.dart';

class PatientReviewsCubit extends Cubit<PatientReviewsStates> {
  PatientReviewsCubit() : super(PatientReviewsInitial());

  void loadReviews(String entityId) async {
    emit(PatientReviewsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final reviews = PatientReviewsMockData.getReviews();
      emit(PatientReviewsLoaded(reviews));
    } catch (e) {
      emit(PatientReviewsError('Failed to load reviews'));
    }
  }

  Future<void> submitReview({
    required String entityId,
    required double rating,
    required double cleanlinessRating,
    required double behaviorRating,
    required double receptionRating,
    String? comment,
  }) async {
    emit(PatientReviewSubmitting());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // For now, we just emit success and reload reviews
      emit(PatientReviewSubmitted());
      loadReviews(entityId);
    } catch (e) {
      emit(PatientReviewsError('Failed to submit review'));
    }
  }
}
