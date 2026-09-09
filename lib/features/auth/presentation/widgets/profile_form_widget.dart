import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/common/widgets/inputs/stitch_upload_field.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String selectedGender;
  final Function(String) onGenderChanged;
  final VoidCallback onSubmit;
  final bool isOwnClinic;
  final TextEditingController? clinicNameController;
  final String? clinicAddress;
  final double? clinicLat;
  final VoidCallback? onPickLocation;
  final String? clinicImageFileName;
  final VoidCallback? onPickClinicImage;
  final List<DayHours>? dayHours;
  final Future<void> Function(int dayIndex, bool isFrom)? onPickTime;
  final void Function(int dayIndex)? onToggleClosed;

  const ProfileFormWidget({
    super.key,
    required this.formKey,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSubmit,
    this.isOwnClinic = false,
    this.clinicNameController,
    this.clinicAddress,
    this.clinicLat,
    this.onPickLocation,
    this.clinicImageFileName,
    this.onPickClinicImage,
    this.dayHours,
    this.onPickTime,
    this.onToggleClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isOwnClinic) ...[
            /// Clinic Image
            StitchUploadField(
              label: 'clinic_image'.tr(),
              fileName: clinicImageFileName,
              hint: 'upload_file_hint'.tr(),
              isRequired: true,
              onPick: onPickClinicImage ?? () {},
            ),
            20.ph,

            /// Clinic Name
            StitchTextField(
              controller: clinicNameController,
              label: 'clinic_name_label'.tr(),
              hintText: 'clinic_name_hint'.tr(),
              prefixIcon: const Icon(
                Icons.local_hospital_outlined,
                color: AppColors.stitchPrimary,
              ),
              validator: null,
            ),
            20.ph,

            /// Clinic Location
            Text(
              'clinic_location'.tr(),
              style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
            ),
            8.ph,
            GestureDetector(
              onTap: onPickLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.stitchSurfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      clinicLat != null
                          ? Icons.check_circle_outline
                          : Icons.location_on_outlined,
                      color: clinicLat != null
                          ? AppColors.stitchPrimary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        clinicAddress?.isNotEmpty == true
                            ? clinicAddress!
                            : 'pick_location_hint'.tr(),
                        style: AppStyles.s16Medium.copyWith(
                          color: clinicAddress?.isNotEmpty == true
                              ? AppColors.onSurface
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.ph,

            /// Operating Hours Header
            Text(
              'operating_hours'.tr(),
              style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
            ),
            12.ph,

            /// Operating Hours Rows
            ...List.generate(dayHours?.length ?? 0, (i) {
              final d = dayHours![i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DayHoursRow(
                  dayName: d.dayName,
                  fromDisplay: d.fromDisplay,
                  toDisplay: d.toDisplay,
                  isClosed: d.isClosed,
                  onPickFrom: () => onPickTime?.call(i, true),
                  onPickTo: () => onPickTime?.call(i, false),
                  onToggleClosed: () => onToggleClosed?.call(i),
                ),
              );
            }),
            32.ph,
          ],

          /// Date of Birth
          StitchTextField(
            label: 'birth_date'.tr(),
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
            'gender'.tr(),
            style: AppStyles.s14Bold.copyWith(color: AppColors.textPrimary),
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
                (isOwnClinic ? 'save_and_continue' : 'complete_setup').tr(),
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
