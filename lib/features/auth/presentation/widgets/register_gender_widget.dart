import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterGenderWidget extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const RegisterGenderWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'gender'.tr(),
          style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
        ),
        8.ph,
        Row(
          children: [
            Expanded(
              child: _GenderChip(
                label: 'male'.tr(),
                isSelected: selectedGender == 'male',
                onTap: () => onGenderChanged('male'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderChip(
                label: 'female'.tr(),
                isSelected: selectedGender == 'female',
                onTap: () => onGenderChanged('female'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderChip(
                label: 'other'.tr(),
                isSelected: selectedGender == 'other',
                onTap: () => onGenderChanged('other'),
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
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.s14Medium.copyWith(
            color: isSelected
                ? AppColors.stitchPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
