import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/patient_reviews/presentation/views/patient_reviews_view.dart';
import 'package:go_router/go_router.dart';

class PatientReviewsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.patientReviews,
      builder: (context, state) {
        final entity = state.extra; // Could be ClinicModel or DoctorModel
        return PatientReviewsView(entity: entity);
      },
    ),
  ];
}
