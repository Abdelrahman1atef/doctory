import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic_details/cubit/clinic_details_cubit.dart';
import 'package:doctory/features/clinic_details/presentation/views/clinic_details_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClinicDetailsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.clinicDetails,
      builder: (context, state) {
        final clinic = state.extra as ClinicModel;
        return BlocProvider(
          create: (_) =>
              sl<ClinicDetailsCubit>()..loadClinicDetails(clinic),
          child: const ClinicDetailsView(),
        );
      },
    ),
  ];
}
