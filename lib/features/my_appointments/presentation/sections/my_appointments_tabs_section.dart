import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_state.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_status_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Status tabs, kept outside the list so they stay on screen while a tab
/// loads and switch selection as soon as they are tapped.
class MyAppointmentsTabsSection extends StatelessWidget {
  const MyAppointmentsTabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
      // Errors keep the last selected tab.
      buildWhen: (_, state) =>
          state is MyAppointmentsLoading || state is MyAppointmentsLoaded,
      builder: (context, state) {
        final AppointmentStatus? selected = switch (state) {
          MyAppointmentsLoading(:final statusFilter) => statusFilter,
          MyAppointmentsLoaded(:final statusFilter) => statusFilter,
          _ => null,
        };
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppointmentStatusTabsWidget(
            selected: selected,
            onSelected: context.read<MyAppointmentsCubit>().loadByStatus,
          ),
        );
      },
    );
  }
}
