import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostAuthorRoleBadge extends StatelessWidget {
  final String? role;
  final bool isFreelanceDoctor;

  const PostAuthorRoleBadge({
    super.key,
    this.role,
    this.isFreelanceDoctor = false,
  });

  bool get _isDoctor =>
      role == 'Doctor' || role == 'FreelanceDoctor' || isFreelanceDoctor;

  bool get _isClinic => role == 'ClinicOwner' || role == 'Clinic';

  @override
  Widget build(BuildContext context) {
    final String? label = _isDoctor
        ? 'doctor_role'.tr()
        : _isClinic
            ? 'clinic_name'.tr()
            : null;
    if (label == null) return const SizedBox.shrink();

    final color = _isClinic ? AppColors.info : AppColors.stitchPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isClinic ? Icons.local_hospital : Icons.medical_services,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppStyles.s10Medium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
