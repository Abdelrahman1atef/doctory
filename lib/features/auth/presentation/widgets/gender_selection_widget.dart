import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GenderSelectionWidget extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderChanged;
  final bool isRequired;

  const GenderSelectionWidget({
    super.key,
    this.selectedGender,
    required this.onGenderChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'gender'.tr(),
                style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyles.s14Bold.copyWith(color: Colors.red),
                )
              else
                TextSpan(
                  text: ' ${'optional'.tr()}',
                  style: AppStyles.s14Bold.copyWith(color: AppColors.textSecondary),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _GenderChip(
                label: 'male'.tr(),
                isSelected: selectedGender == 'male',
                onTap: () => onGenderChanged('male'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _GenderChip(
                label: 'female'.tr(),
                isSelected: selectedGender == 'female',
                onTap: () => onGenderChanged('female'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.stitchPrimary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.cardBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.stitchPrimary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: AppStyles.s14Bold.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
