import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class RoleSelectionWidget extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoleCard(
          icon: Icons.medical_services_outlined,
          title: context.l10n('doctor_role'),
          description: context.l10n('doctor_role_desc'),
          isSelected: selectedRole == 'doctor',
          onTap: () => onRoleSelected('doctor'),
        ),
        const SizedBox(height: 16),
        _RoleCard(
          icon: Icons.person_outline,
          title: context.l10n('patient_role'),
          description: context.l10n('patient_role_desc'),
          isSelected: selectedRole == 'patient',
          onTap: () => onRoleSelected('patient'),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimary.withValues(alpha: 0.08)
              : AppColors.stitchSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.stitchPrimary
                : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? AppColors.stitchPrimary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextSizes.s16.bold.copyWith(
                      color: isSelected
                          ? AppColors.stitchPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  4.ph,
                  Text(
                    description,
                    style: AppTextSizes.s14.regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.stitchPrimary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}