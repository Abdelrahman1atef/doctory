import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileFormSection extends StatefulWidget {
  const ProfileFormSection({super.key});

  @override
  State<ProfileFormSection> createState() => _ProfileFormSectionState();
}

class _ProfileFormSectionState extends State<ProfileFormSection> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = 'male';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Date of Birth
          StitchTextField(
            label: context.tr('birth_date'),
            hintText: 'DD / MM / YYYY',
            prefixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.stitchPrimary),
            keyboardType: TextInputType.datetime,
          ),
          
          32.ph,
          
          /// Gender Selection
          Text(
            context.tr('gender'),
            style: AppStyles.s14Bold.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GenderChip(
                  label: context.tr('male'),
                  isSelected: _selectedGender == 'male',
                  onTap: () => setState(() => _selectedGender = 'male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: context.tr('female'),
                  isSelected: _selectedGender == 'female',
                  onTap: () => setState(() => _selectedGender = 'female'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: context.tr('other'),
                  isSelected: _selectedGender == 'other',
                  onTap: () => setState(() => _selectedGender = 'other'),
                ),
              ),
            ],
          ),
          
          64.ph,
          
          /// Save Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.locationPermission),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(context.tr('complete_setup'), style: AppStyles.s16SemiBold),
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
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.stitchPrimary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : [],
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
