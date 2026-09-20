import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_cubit.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_actions_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_window_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClinicAvailabilityActionsSection extends StatelessWidget {
  const ClinicAvailabilityActionsSection({super.key});

  /// Query flag set by the booking-config screen during first-time setup.
  static const String onboardingParam = 'onboarding';

  void _openAddSheet(BuildContext context) {
    final cubit = context.read<ClinicAvailabilityCubit>();
    Alerts.bottomSheet(
      context,
      child: AvailabilityWindowSheet(
        doctorId: UserSession.doctorId ?? '',
        clinicId: UserSession.clinicId ?? '',
        onSave: cubit.addAvailability,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnboarding =
        GoRouterState.of(context).uri.queryParameters[onboardingParam] == 'true';

    return AvailabilityActionsWidget(
      onAdd: () => _openAddSheet(context),
      // Only the onboarding flow needs an explicit way out to the dashboard.
      onFinish: isOnboarding ? () => context.go(AppRoutes.clinicDashboard) : null,
    );
  }
}
