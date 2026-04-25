import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic_details/presentation/views/clinic_details_view.dart';
import 'package:go_router/go_router.dart';

class ClinicDetailsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.clinicDetails,
      builder: (context, state) {
        final clinic = state.extra as ClinicModel;
        return ClinicDetailsView(clinic: clinic);
      },
    ),
  ];
}
