import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DoctorAboutSection extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorAboutSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about_doctor'.tr(),
            style: AppStyles.s18Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
          12.ph,
          Text(
            doctor.displayBio,
            style: AppStyles.s14Medium
                .withColor(AppColors.stitchSecondary)
                .copyWith(height: 1.5),
          ),
          if (doctor.qualifications != null &&
              doctor.qualifications!.isNotEmpty) ...[
            16.ph,
            ...doctor.qualifications!.map(
              (q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: AppColors.stitchPrimaryContainer,
                      ),
                    ),
                    8.pw,
                    Expanded(
                      child: Text(
                        q,
                        style: AppStyles.s14Medium.withColor(
                          AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
