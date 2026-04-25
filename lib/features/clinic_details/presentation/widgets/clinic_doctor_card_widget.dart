import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class ClinicDoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const ClinicDoctorCardWidget({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.stitchSurfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.stitchSurfaceLow),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(doctor.imageUrl ?? ''),
              onBackgroundImageError: (_, __) {},
              backgroundColor: AppColors.stitchSurfaceLow,
              child: doctor.imageUrl == null
                  ? const Icon(Icons.person, color: AppColors.stitchSecondary)
                  : null,
            ),
            12.ph,
            Text(
              doctor.displayName,
              style: AppStyles.s14Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            4.ph,
            Text(
              doctor.displaySpecialty,
              style: AppStyles.s12Medium.withColor(AppColors.stitchSecondary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
