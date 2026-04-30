import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class ProfileFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String selectedGender;
  final Function(String) onGenderChanged;
  final VoidCallback onSubmit;

  const ProfileFormWidget({
    super.key,
    required this.formKey,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Date of Birth
          StitchTextField(
            label: context.l10n('birth_date'),
            hintText: 'DD / MM / YYYY',
            prefixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.stitchPrimary,
            ),
            keyboardType: TextInputType.datetime,
          ),

          32.ph,

          /// Gender Selection
          Text(
            context.l10n('gender'),
            style: AppStyles.s14Bold.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GenderChip(
                  label: context.l10n('male'),
                  isSelected: selectedGender == 'male',
                  onTap: () => onGenderChanged('male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: context.l10n('female'),
                  isSelected: selectedGender == 'female',
                  onTap: () => onGenderChanged('female'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: context.l10n('other'),
                  isSelected: selectedGender == 'other',
                  onTap: () => onGenderChanged('other'),
                ),
              ),
            ],
          ),

          64.ph,

          /// Save Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n('complete_setup'),
                style: AppStyles.s16SemiBold,
              ),
            ),
          ),
        ],
      ),
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
