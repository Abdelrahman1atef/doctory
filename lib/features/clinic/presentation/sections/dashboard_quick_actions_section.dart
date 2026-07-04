import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_booking_queue_section.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_patient_search_section.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _TabButton(
                    label: LocaleKeys.pending_bookings.tr(),
                    isSelected: state.selectedTabIndex == 0,
                    onTap: () {
                      context.read<ClinicDashboardCubit>().switchTab(1);
                    },
                  ),
                  _TabButton(
                    label: LocaleKeys.search_patient.tr(),
                    isSelected: state.selectedTabIndex == 2,
                    onTap: () {
                      context.read<ClinicDashboardCubit>().switchTab(2);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: state.selectedTabIndex == 2 ? 1 : 0,
                children: const [
                  DashboardBookingQueueSection(),
                  DashboardPatientSearchSection(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.stitchPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.s14Medium.withColor(
              isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
