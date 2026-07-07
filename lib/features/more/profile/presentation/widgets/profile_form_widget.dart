import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final String selectedGender;
  final Function(String) onGenderChanged;
  final VoidCallback onSubmit;
  final bool isSaveEnabled;

  const ProfileFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSubmit,
    this.isSaveEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Full Name
          StitchTextField(
            controller: nameController,
            label: context.l10n('full_name'),
            hintText: 'John Doe',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) => value == null || value.isEmpty
                ? context.l10n('field_required')
                : null,
          ),

          20.ph,

          /// Phone Number
          StitchTextField(
            controller: phoneController,
            label: context.l10n('phone_number'),
            hintText: '01XXXXXXXXX',
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textDirection: TextDirection.ltr,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇪🇬', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Text(
                    '+20',
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 20, color: AppColors.cardBorder),
                ],
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return context.l10n('field_required');
              if (value.length != 11) return context.l10n('invalid_phone');
              return null;
            },
          ),

          20.ph,

          /// Birth Date Split (Day, Month, Year)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.l10n('birth_date'),
                  style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
                ),
                TextSpan(
                  text: ' ${context.l10n('optional')}',
                  style: AppStyles.s14Bold.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          8.ph,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: StitchTextField(
                  controller: dayController,
                  hintText: context.l10n('day'),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final day = int.tryParse(value);
                    if (day == null || day < 1 || day > 31) return '';
                    return null;
                  },
                ),
              ),
              12.pw,
              Expanded(
                flex: 2,
                child: StitchTextField(
                  controller: monthController,
                  hintText: context.l10n('month'),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final month = int.tryParse(value);
                    if (month == null || month < 1 || month > 12) return '';
                    return null;
                  },
                ),
              ),
              12.pw,
              Expanded(
                flex: 3,
                child: StitchTextField(
                  controller: yearController,
                  hintText: context.l10n('year'),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year)
                      return '';
                    return null;
                  },
                ),
              ),
            ],
          ),

          20.ph,

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
            ],
          ),

          40.ph,

          /// Save Button
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaveEnabled ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaveEnabled ? AppColors.stitchPrimaryContainer : Colors.transparent,
                foregroundColor: isSaveEnabled ? Colors.white : AppColors.textSecondary,
                elevation: 0,
                side: isSaveEnabled ? null : BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n('save'),
                style: AppStyles.s16SemiBold.copyWith(
                  color: isSaveEnabled ? Colors.white : AppColors.textSecondary,
                ),
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
          color: isSelected ? AppColors.stitchPrimaryContainer : Colors.white,
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
