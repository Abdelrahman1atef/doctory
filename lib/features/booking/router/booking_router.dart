import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/presentation/views/booking_success_view.dart';
import 'package:doctory/features/booking/presentation/views/confirm_booking_view.dart';
import 'package:doctory/features/booking/presentation/views/select_date_view.dart';
import 'package:doctory/features/booking/presentation/views/select_time_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.bookingSelectDate,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        final doctor = params?['doctor'] as DoctorModel;

        return BlocProvider(
          create: (context) => BookingCubit(doctor: doctor),
          child: const SelectDateView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSelectTime,
      builder: (context, state) {
        final cubit = state.extra as BookingCubit;
        return BlocProvider.value(value: cubit, child: const SelectTimeView());
      },
    ),
    GoRoute(
      path: AppRoutes.bookingConfirm,
      builder: (context, state) {
        final cubit = state.extra as BookingCubit;
        return BlocProvider.value(
          value: cubit,
          child: const ConfirmBookingView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      builder: (context, state) => const BookingSuccessView(),
    ),
  ];
}
