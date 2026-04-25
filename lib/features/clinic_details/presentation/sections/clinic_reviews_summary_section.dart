import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClinicReviewsSummarySection extends StatelessWidget {
  final ClinicModel clinic;
  final VoidCallback onSeeAll;

  const ClinicReviewsSummarySection({
    super.key,
    required this.clinic,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stitchSurfaceLow),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
              ),
              16.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${clinic.rating} / 5.0',
                    style: AppStyles.s18Bold.withColor(
                      AppColors.stitchPrimaryContainer,
                    ),
                  ),
                  4.ph,
                  Text(
                    'Based on ${clinic.reviewsCount} reviews', // Can localize
                    style: AppStyles.s12Medium.withColor(
                      AppColors.stitchSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'reviews'.tr(),
              style: AppStyles.s14Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
