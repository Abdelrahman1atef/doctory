import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic_dashboard/presentation/views/clinic_dashboard_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class ClinicDashboardRouter {
  static List<GoRoute> get routes => [
    GoRoute(
      path: AppRoutes.clinicDashboard,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ClinicDashboardCubit>()..loadDashboard(),
        child: const ClinicDashboardView(),
      ),
    ),
  ];
}
