import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/doctor_details/presentation/views/doctor_details_view.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.doctorDetails,
      builder: (context, state) {
        final doctor = state.extra as DoctorModel;
        return DoctorDetailsView(doctor: doctor);
      },
    ),
  ];
}
