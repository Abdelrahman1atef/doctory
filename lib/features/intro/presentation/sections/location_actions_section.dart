import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationActionsSection extends StatelessWidget {
  const LocationActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Primary CTA (Allow Access)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Handle permission then navigate to main
              context.go(AppRoutes.mainLayout);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stitchPrimaryContainer,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.tr('allow_location'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Secondary CTA (Not now)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: () {
              context.go(AppRoutes.mainLayout);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.stitchPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.tr('not_now'), style: AppStyles.s16SemiBold),
          ),
        ),
      ],
    );
  }
}
