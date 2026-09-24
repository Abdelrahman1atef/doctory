import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_cubit.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_actions_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_window_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
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

  Future<void> _finishSetup(BuildContext context) async {
    final cubit = context.read<ClinicAvailabilityCubit>();
    if (cubit.currentAvailability.isEmpty) {
      Alerts.snack(text: LocaleKeys.add_at_least_one_slot.tr(), state: SnackState.failed);
      return;
    }

    // Re-check with the server before leaving the wizard — the flag is only
    // guaranteed true once both booking-config and availability exist.
    final result = await sl<AuthRepo>().getProfile();
    result.fold(
      onSuccess: (user) => UserSession.updateCompleteProfile(user.isCompleteProfile),
      onFailure: (_) {},
    );

    if (!context.mounted) return;
    if (UserSession.isCompleteProfile == false) {
      Alerts.snack(text: LocaleKeys.complete_booking_config_first.tr(), state: SnackState.failed);
      return;
    }
    context.go(AppRoutes.clinicDashboard);
  }

  @override
  Widget build(BuildContext context) {
    final isOnboarding =
        GoRouterState.of(context).uri.queryParameters[onboardingParam] == 'true';

    return AvailabilityActionsWidget(
      onAdd: () => _openAddSheet(context),
      // Only the onboarding flow needs an explicit way out to the dashboard.
      onFinish: isOnboarding ? () => _finishSetup(context) : null,
    );
  }
}
