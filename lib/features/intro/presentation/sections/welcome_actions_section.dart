import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeActionsSection extends StatelessWidget {
  const WelcomeActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Primary CTA (Login / Get Started)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              context.push(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stitchPrimaryContainer,
              foregroundColor: AppColors.stitchOnPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // rounded-md (0.75rem)
              ),
            ),
            child: Text(
              context.tr('start_now'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        /// Secondary CTA (Browse Clinics)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: () {
              // Navigate to Home/Search
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.stitchPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.tr('browse_clinics'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),
      ],
    );
  }
}
