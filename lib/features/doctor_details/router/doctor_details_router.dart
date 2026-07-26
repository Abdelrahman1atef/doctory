import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/doctor_details/cubit/doctor_details_cubit.dart';
import 'package:doctory/features/doctor_details/presentation/views/doctor_details_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.doctorDetails,
      builder: (context, state) {
        final doctor = state.extra as DoctorModel;
        return BlocProvider(
          create: (_) =>
              sl<DoctorDetailsCubit>()..loadDoctorDetails(doctor.id),
          child: DoctorDetailsView(doctor: doctor),
        );
      },
    ),
  ];
}
