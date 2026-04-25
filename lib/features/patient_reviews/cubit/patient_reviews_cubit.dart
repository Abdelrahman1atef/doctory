import 'package:flutter_bloc/flutter_bloc.dart';
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
}
