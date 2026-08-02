import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/data/data_source/my_appointments_remote_data_source.dart';
import 'package:doctory/features/my_appointments/presentation/views/appointment_details_view.dart';
import 'package:doctory/features/my_appointments/presentation/views/my_appointments_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyAppointmentsRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.myAppointments,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<MyAppointmentsCubit>(),
        child: const MyAppointmentsView(),
      ),
    ),
  ];

  static final GoRoute detailsRoute = GoRoute(
    path: AppRoutes.appointmentDetails,
    builder: (context, state) {
      final id = state.uri.queryParameters['id'];
      final paymentUrl = state.uri.queryParameters['paymentUrl'];
      return BlocProvider(
        create: (_) => MyAppointmentsCubit(
          remoteDataSource: sl<MyAppointmentsRemoteDataSource>(),
          autoLoad: false,
        ),
        child: AppointmentDetailsView(
          appointmentId: id,
          paymentUrl: paymentUrl,
        ),
      );
    },
  );
}
