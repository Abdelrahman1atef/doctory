import 'package:doctory/core/common/models/shared_models.dart';

class PatientReviewsMockData {
  static List<ReviewModel> getReviews() {
    return [
      ReviewModel(
        id: 'r1',
        patientName: 'Omar Hassan',
        rating: 5.0,
        cleanlinessRating: 5.0,
        behaviorRating: 5.0,
        receptionRating: 5.0,
        comment:
            'Excellent clinic and very professional staff. Dr. Ahmed is the best cardiologist I have ever visited. Highly recommended!',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'r2',
        patientName: 'Maha Ali',
        rating: 4.5,
        cleanlinessRating: 4.0,
        behaviorRating: 5.0,
        receptionRating: 4.5,
        comment:
            'The waiting time was a bit long, but the doctor was very attentive and explained everything clearly.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: 'r3',
        patientName: 'Khaled Saeed',
        rating: 5.0,
        cleanlinessRating: 5.0,
        behaviorRating: 5.0,
        receptionRating: 5.0,
        comment:
            'Very clean facility and friendly reception. The appointment was exactly on time.',
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
      ReviewModel(
        id: 'r4',
        patientName: 'Nour El-Din',
        rating: 4.0,
        cleanlinessRating: 3.5,
        behaviorRating: 4.5,
        receptionRating: 4.0,
        comment:
            'Good overall experience, but parking nearby is difficult to find.',
        date: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }
}
