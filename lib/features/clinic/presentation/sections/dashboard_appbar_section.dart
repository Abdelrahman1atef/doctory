import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardAppbarSection extends StatelessWidget {
  const DashboardAppbarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.clinic_dashboard.tr(),
                style: AppStyles.s20Bold.withColor(AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                LocaleKeys.clinic_dashboard_subtitle.tr(),
                style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
