import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_target.dart';
import 'package:doctory/features/patient_reviews/presentation/views/patient_reviews_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientReviewsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.patientReviews,
      builder: (context, state) {
        final entity = state.extra; // Could be ClinicModel or DoctorModel
        final target = _targetFromEntity(entity) ?? const RatingTarget.clinic('');
        return BlocProvider(
          create: (_) => sl<PatientReviewsCubit>()..loadReviews(target),
          child: PatientReviewsView(entity: entity, target: target),
        );
      },
    ),
  ];

  static RatingTarget? _targetFromEntity(dynamic entity) {
    if (entity is DoctorModel) return RatingTarget.doctor(entity.id);
    if (entity is ClinicModel) return RatingTarget.clinic(entity.id);
    return null;
  }
}