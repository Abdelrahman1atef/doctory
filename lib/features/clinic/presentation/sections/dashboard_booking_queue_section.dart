import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/presentation/widgets/booking_request_card_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/dashboard_empty_widget.dart';

class DashboardBookingQueueSection extends StatelessWidget {
  const DashboardBookingQueueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }
        final bookings = state.bookings;
        if (bookings.isEmpty) {
          return const DashboardEmptyWidget(
            icon: Icons.check_circle_outline,
            message: '',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return BookingRequestCardWidget(
              booking: booking,
              onAccept: () {
                context.read<ClinicDashboardCubit>().acceptBooking(booking.id);
              },
              onReject: () {
                context.read<ClinicDashboardCubit>().rejectBooking(booking.id);
              },
            );
          },
        );
      },
    );
  }
}
