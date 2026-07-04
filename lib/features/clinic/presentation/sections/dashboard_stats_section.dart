import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/presentation/widgets/stat_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardStatsSection extends StatelessWidget {
  const DashboardStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }
        final stats = state.stats;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              StatCardWidget(
                icon: Icons.people_alt_outlined,
                label: LocaleKeys.todays_visits.tr(),
                value: stats.todayVisits.toString(),
                color: AppColors.stitchPrimary,
              ),
              StatCardWidget(
                icon: Icons.attach_money,
                label: LocaleKeys.todays_income.tr(),
                value: '${stats.todayIncome.toStringAsFixed(0)} ${'currency_egp'.tr()}',
                color: AppColors.success,
              ),
              StatCardWidget(
                icon: Icons.pending_actions,
                label: LocaleKeys.pending_actions.tr(),
                value: stats.pendingActions.toString(),
                color: AppColors.warning,
              ),
            ],
          ),
        );
      },
    );
  }
}
