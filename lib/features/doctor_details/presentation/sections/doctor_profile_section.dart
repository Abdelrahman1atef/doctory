import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorProfileSection extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorProfileSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.stitchSurfaceLow, width: 4),
              image: DecorationImage(
                image: NetworkImage(doctor.imageUrl!.toImageUrl),
                fit: BoxFit.cover,
                onError: (_, __) {},
              ),
            ),
            child: doctor.imageUrl == null
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.stitchSecondary,
                  )
                : null,
          ),
        ),
        16.ph,
        // Name and Specialty
        Text(
          doctor.displayName,
          style: AppStyles.s24Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        4.ph,
        Text(
          doctor.displaySpecialty,
          style: AppStyles.s16Medium.withColor(AppColors.stitchSecondary),
        ),
        8.ph,
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.patientReviews,
            extra: doctor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              4.pw,
              Text(
                doctor.rating.toString(),
                style: AppStyles.s14Bold.withColor(
                  AppColors.stitchSecondary,
                ),
              ),
              8.pw,
              Text(
                '(${doctor.reviewsCount} ${'reviews'.tr()})',
                style: AppStyles.s14Medium
                    .withColor(AppColors.stitchSecondary)
                    .underline(),
              ),
            ],
          ),
        ),
        24.ph,
        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildStatCard(
            //   'patients'.tr(),
            //   '${doctor.patientsCount ?? 0}+',
            //   Icons.people_outline,
            // ),
            _buildStatCard(
              'experience'.tr(),
              '${doctor.experience ?? 0} ${'years'.tr()}',
              Icons.work_outline,
            ),
            20.pw,
            _buildStatCard(
              LocaleKeys.rating.tr(),
              doctor.rating.toString(),
              Icons.star_border,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.stitchPrimaryContainer,
              size: 24,
            ),
          ),
          12.ph,
          Text(
            value,
            style: AppStyles.s16Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
          4.ph,
          Text(
            label,
            style: AppStyles.s12Medium.withColor(AppColors.stitchSecondary),
          ),
        ],
      ),
    );
  }
}
