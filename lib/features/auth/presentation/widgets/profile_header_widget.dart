import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Title
        Text(
          'complete_profile_title'.tr(),
          textAlign: TextAlign.center,
          style: AppStyles.s26Bold.copyWith(
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 12),

        /// Subtitle
        Text(
          'complete_profile_subtitle'.tr(),
          textAlign: TextAlign.center,
          style: AppStyles.s16Medium.copyWith(color: AppColors.textSecondary),
        ),

        const SizedBox(height: 40),

        /// Profile Photo Placeholder (Minimalist)
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.stitchPrimary.withValues(alpha: 0.1),
                  width: 4,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 64,
                color: AppColors.stitchSecondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.stitchPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
