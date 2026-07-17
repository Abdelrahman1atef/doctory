import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardPeriodStatsSection extends StatelessWidget {
  const DashboardPeriodStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }
        final stats = state.stats;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  LocaleKeys.period_overview.tr(),
                  style: AppStyles.s16Bold.withColor(AppColors.textPrimary),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _PeriodCard(
                      title: LocaleKeys.visits.tr(),
                      periods: [
                        _PeriodRow(LocaleKeys.weekly.tr(), stats.weeklyVisits.toString()),
                        _PeriodRow(LocaleKeys.monthly.tr(), stats.monthlyVisits.toString()),
                        _PeriodRow(LocaleKeys.yearly.tr(), stats.yearlyVisits.toString()),
                      ],
                      icon: Icons.people_alt_outlined,
                      color: AppColors.stitchPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PeriodCard(
                      title: LocaleKeys.income.tr(),
                      periods: [
                        _PeriodRow(LocaleKeys.weekly.tr(), '${stats.weeklyIncome.toStringAsFixed(0)} ${'currency_egp'.tr()}'),
                        _PeriodRow(LocaleKeys.monthly.tr(), '${stats.monthlyIncome.toStringAsFixed(0)} ${'currency_egp'.tr()}'),
                        _PeriodRow(LocaleKeys.yearly.tr(), '${stats.yearlyIncome.toStringAsFixed(0)} ${'currency_egp'.tr()}'),
                      ],
                      icon: Icons.attach_money,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PeriodRow {
  final String label;
  final String value;
  const _PeriodRow(this.label, this.value);
}

class _PeriodCard extends StatelessWidget {
  final String title;
  final List<_PeriodRow> periods;
  final IconData icon;
  final Color color;

  const _PeriodCard({
    required this.title,
    required this.periods,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppStyles.s14SemiBold.withColor(AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...periods.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  p.label,
                  style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
                ),
                Text(
                  p.value,
                  style: AppStyles.s13Bold.withColor(AppColors.textPrimary),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
