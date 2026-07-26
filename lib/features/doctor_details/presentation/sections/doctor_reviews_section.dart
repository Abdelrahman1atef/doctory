import 'package:doctory/core/common/models/doctor_rating_summary_dto.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DoctorReviewsSection extends StatelessWidget {
  final List<DoctorRatingSummaryDto> ratings;

  const DoctorReviewsSection({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'patient_reviews'.tr(),
            style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
          ),
          16.ph,
          ...ratings.take(3).map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: r.reviewerProfilePictureUrl != null
                        ? NetworkImage(r.reviewerProfilePictureUrl!)
                        : null,
                    backgroundColor: AppColors.stitchSurfaceLow,
                    child: r.reviewerProfilePictureUrl == null
                        ? const Icon(Icons.person, size: 20, color: AppColors.stitchSecondary)
                        : null,
                  ),
                  12.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.reviewerName,
                          style: AppStyles.s14Bold.withColor(AppColors.stitchPrimaryContainer),
                        ),
                        4.ph,
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < r.value ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          )),
                        ),
                        if (r.review != null && r.review!.isNotEmpty) ...[
                          4.ph,
                          Text(
                            r.review!,
                            style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
