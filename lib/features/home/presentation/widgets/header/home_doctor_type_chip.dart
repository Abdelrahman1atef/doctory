import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_spacing.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Small tinted chip naming the doctor's employment type.
class HomeDoctorTypeChip extends StatelessWidget {
  final DoctorEmploymentType doctorType;

  const HomeDoctorTypeChip({super.key, required this.doctorType});

  String get _label => switch (doctorType) {
    DoctorEmploymentType.freelance => 'freelance_doctor'.tr(),
    DoctorEmploymentType.ownClinic => 'clinic_owner'.tr(),
    DoctorEmploymentType.inCenter => 'doctor'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: AppColors.stitchPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.r4),
      ),
      child: Text(
        _label,
        style: AppStyles.s12Medium.copyWith(color: AppColors.stitchPrimary),
      ),
    );
  }
}
