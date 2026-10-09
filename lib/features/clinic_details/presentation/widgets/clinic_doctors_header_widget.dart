import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Title, doctors count badge and a hint that booking is available here.
class ClinicDoctorsHeaderWidget extends StatelessWidget {
  final int count;

  const ClinicDoctorsHeaderWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'available_doctors'.tr(),
                  style: AppStyles.s18Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: AppStyles.s13Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          4.ph,
          Text(
            'clinic_doctors_book_hint'.tr(),
            style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
          ),
        ],
      ),
    );
  }
}
