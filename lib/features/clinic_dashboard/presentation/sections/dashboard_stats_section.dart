import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic_dashboard/presentation/widgets/stat_card_widget.dart';

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
                label: "Today's Visits",
                value: stats.todayVisits.toString(),
                color: AppColors.stitchPrimary,
              ),
              StatCardWidget(
                icon: Icons.attach_money,
                label: "Today's Income",
                value: '${stats.todayIncome.toStringAsFixed(0)} EGP',
                color: AppColors.success,
              ),
              StatCardWidget(
                icon: Icons.pending_actions,
                label: 'Pending Actions',
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
