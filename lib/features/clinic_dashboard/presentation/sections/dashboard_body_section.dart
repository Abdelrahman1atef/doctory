import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic_dashboard/presentation/sections/dashboard_appbar_section.dart';
import 'package:doctory/features/clinic_dashboard/presentation/sections/dashboard_stats_section.dart';
import 'package:doctory/features/clinic_dashboard/presentation/sections/dashboard_quick_actions_section.dart';

class DashboardBodySection extends StatelessWidget {
  const DashboardBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        if (state is ClinicDashboardLoading) {
          return Column(
            children: const [
              DashboardAppbarSection(),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        if (state is ClinicDashboardError) {
          return Column(
            children: [
              const DashboardAppbarSection(),
              Expanded(
                child: AppErrorWidget(message: state.message),
              ),
            ],
          );
        }

        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          children: const [
            DashboardAppbarSection(),
            DashboardStatsSection(),
            Expanded(
              child: DashboardQuickActionsSection(),
            ),
          ],
        );
      },
    );
  }
}
