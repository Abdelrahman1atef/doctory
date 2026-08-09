import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.patientName,
                style: AppStyles.s16Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  4.pw,
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: AppStyles.s14Bold.withColor(
                      AppColors.stitchSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          4.ph,
          Row(
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(review.date),
                style: AppStyles.s12Medium.withColor(
                  AppColors.stitchSecondary.withValues(alpha: 0.6),
                ),
              ),
              if (_typeLabel(review.type) != null) ...[
                8.pw,
                _buildTypeTag(_typeLabel(review.type)!),
              ],
            ],
          ),
          16.ph,
          Text(
            review.comment,
            style: AppStyles.s14Medium
                .withColor(AppColors.textPrimary)
                .copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  String? _typeLabel(int type) {
    return switch (type) {
      1 => LocaleKeys.rate_doctor.tr(),
      2 => LocaleKeys.rate_clinic.tr(),
      3 => LocaleKeys.place_cleanliness.tr(),
      _ => null,
    };
  }

  Widget _buildTypeTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppStyles.s10Medium.withColor(AppColors.stitchSecondary),
      ),
    );
  }
}