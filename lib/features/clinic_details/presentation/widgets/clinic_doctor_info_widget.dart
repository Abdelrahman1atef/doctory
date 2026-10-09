import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Doctor name, specialty, rating and experience shown inside the clinic card.
class ClinicDoctorInfoWidget extends StatelessWidget {
  final DoctorModel doctor;

  const ClinicDoctorInfoWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final experience = doctor.experience ?? 0;
    final hasRating = doctor.rating > 0;
    final hasExperience = experience > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.displayName,
          style: AppStyles.s16Bold.withColor(AppColors.stitchPrimaryContainer),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        4.ph,
        Text(
          doctor.displaySpecialty,
          style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (hasRating || hasExperience) ...[
          8.ph,
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (hasRating)
                _DoctorMetaItem(
                  icon: Icons.star_rounded,
                  color: AppColors.rate,
                  label:
                      '${doctor.rating.toStringAsFixed(1)} (${doctor.reviewsCount})',
                ),
              if (hasExperience)
                _DoctorMetaItem(
                  icon: Icons.work_outline_rounded,
                  color: AppColors.stitchSecondary,
                  label: '$experience ${'years'.tr()}',
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DoctorMetaItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _DoctorMetaItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        4.pw,
        Text(label, style: AppStyles.s12Medium.withColor(color)),
      ],
    );
  }
}
