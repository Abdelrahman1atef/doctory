import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/presentation/views/booking_flow_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.bookingSelectDate, // We keep this name for compatibility
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        final doctor = params?['doctor'] as DoctorModel;

        return BlocProvider(
          create: (context) => BookingCubit(doctor: doctor),
          child: const BookingFlowView(),
        );
      },
    ),
    // The other routes (bookingSelectTime, bookingConfirm, bookingSuccess)
    // have been removed as the flow is now contained in a single BookingFlowView
  ];
}
