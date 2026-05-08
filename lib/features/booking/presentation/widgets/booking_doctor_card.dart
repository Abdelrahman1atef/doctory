import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Compact doctor info card shown at the top of the booking flow.
class BookingDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const BookingDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Doctor Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.stitchPrimaryFixed,
              image: doctor.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(doctor.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.imageUrl == null
                ? const Icon(
                    Icons.person,
                    color: AppColors.stitchPrimary,
                    size: 28,
                  )
                : null,
          ),
          12.pw,
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.displayName,
                  style: AppStyles.s16Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
                4.ph,
                Text(
                  doctor.displaySpecialty,
                  style: AppStyles.s13Medium.withColor(
                    AppColors.stitchSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Rating
          if (doctor.rating > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.rate.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColors.rate,
                  ),
                  4.pw,
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: AppStyles.s13Bold.withColor(AppColors.rate),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
