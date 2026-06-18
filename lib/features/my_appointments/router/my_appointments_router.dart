import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
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
    GoRoute(
      path: AppRoutes.appointmentDetails,
      builder: (context, state) {
        final appointment = state.extra as AppointmentResponseDto;
        return BlocProvider(
          create: (_) => sl<MyAppointmentsCubit>(),
          child: AppointmentDetailsView(appointment: appointment),
        );
      },
    ),
  ];
}
