import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class DoctorTypeSelectionWidget extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;

  const DoctorTypeSelectionWidget({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeCard(
          icon: Icons.person_pin_outlined,
          title: context.l10n('freelance_doctor'),
          description: context.l10n('freelance_doctor_desc'),
          isSelected: selectedType == 'freelance',
          onTap: () => onTypeSelected('freelance'),
        ),
        const SizedBox(height: 16),
        _TypeCard(
          icon: Icons.local_hospital_outlined,
          title: context.l10n('clinic_owner'),
          description: context.l10n('clinic_owner_desc'),
          isSelected: selectedType == 'ownClinic',
          onTap: () => onTypeSelected('ownClinic'),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
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
