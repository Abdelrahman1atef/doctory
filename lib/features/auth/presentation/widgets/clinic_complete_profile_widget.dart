import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/common/widgets/inputs/stitch_upload_field.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class ClinicCompleteProfileWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isSetupMode;
  final TextEditingController clinicNameController;
  final TextEditingController? descriptionController;
  final TextEditingController? emailController;
  final TextEditingController? websiteController;
  final String clinicAddress;
  final double? clinicLat;
  final String? clinicImageFileName;
  final VoidCallback onPickClinicImage;
  final VoidCallback onPickLocation;
  final List<DayHours> dayHours;
  final Future<void> Function(int dayIndex, bool isFrom) onPickTime;
  final void Function(int dayIndex) onToggleClosed;
  final String? selectedSpecializationName;
  final VoidCallback onPickSpecialization;
  final VoidCallback onSubmit;

  const ClinicCompleteProfileWidget({
    super.key,
    required this.formKey,
    this.isSetupMode = false,
    required this.clinicNameController,
    this.descriptionController,
    this.emailController,
    this.websiteController,
    required this.clinicAddress,
    required this.clinicLat,
    required this.clinicImageFileName,
    required this.onPickClinicImage,
    required this.onPickLocation,
    required this.dayHours,
    required this.onPickTime,
    required this.onToggleClosed,
    this.selectedSpecializationName,
    required this.onPickSpecialization,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header
            Text(
              (isSetupMode ? 'setup_clinic_title' : 'complete_profile_title').tr(),
              style: AppStyles.s24Bold.copyWith(color: AppColors.onSurface),
            ),
            8.ph,
            Text(
              (isSetupMode ? 'setup_clinic_subtitle' : 'complete_profile_subtitle').tr(),
              style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
            ),
            32.ph,

            /// Clinic Image
            StitchUploadField(
              label: 'clinic_image'.tr(),
              fileName: clinicImageFileName,
              hint: 'upload_file_hint'.tr(),
              isRequired: isSetupMode,
              onPick: onPickClinicImage,
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
            ),
            20.ph,

            /// Description (setup mode only)
            if (isSetupMode) ...[
              StitchTextField(
                controller: descriptionController,
                label: 'clinic_description_label'.tr(),
                hintText: 'clinic_description_hint'.tr(),
                maxLines: 3,
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  color: AppColors.stitchPrimary,
                ),
              ),
              20.ph,
            ],

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
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.stitchPrimary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        clinicLat != null
                            ? Icons.check_circle_rounded
                            : Icons.location_on_outlined,
                        color: clinicLat != null
                            ? AppColors.stitchPrimary
                            : AppColors.textSecondary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        clinicAddress.isNotEmpty
                            ? clinicAddress
                            : 'pick_location_hint'.tr(),
                        style: AppStyles.s16Medium.copyWith(
                          color: clinicAddress.isNotEmpty
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

            /// Email (setup mode only)
            if (isSetupMode) ...[
              StitchTextField(
                controller: emailController,
                label: 'email_label'.tr(),
                hintText: 'email_hint'.tr(),
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.stitchPrimary,
                ),
              ),
              20.ph,
            ],

            /// Website (setup mode only)
            if (isSetupMode) ...[
              StitchTextField(
                controller: websiteController,
                label: 'website_label'.tr(),
                hintText: 'website_hint'.tr(),
                keyboardType: TextInputType.url,
                isRequired: false,
                prefixIcon: const Icon(
                  Icons.language_outlined,
                  color: AppColors.stitchPrimary,
                ),
              ),
              20.ph,
            ],

            /// Specialization (setup mode only)
            if (isSetupMode) ...[
              Text(
                'specialization'.tr(),
                style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
              ),
              8.ph,
              GestureDetector(
                onTap: onPickSpecialization,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.stitchSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.stitchPrimary.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          color: AppColors.stitchPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          selectedSpecializationName ??
                              'select_specialization'.tr(),
                          style: AppStyles.s16Medium.copyWith(
                            color: selectedSpecializationName != null
                                ? AppColors.onSurface
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              20.ph,
            ],

            /// Operating Hours Header
            Text(
              'operating_hours'.tr(),
              style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
            ),
            12.ph,

            /// Operating Hours Rows
            ...List.generate(dayHours.length, (i) {
              final d = dayHours[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DayHoursRow(
                  dayName: d.dayName,
                  fromDisplay: d.fromDisplay,
                  toDisplay: d.toDisplay,
                  isClosed: d.isClosed,
                  onPickFrom: () => onPickTime(i, true),
                  onPickTo: () => onPickTime(i, false),
                  onToggleClosed: () => onToggleClosed(i),
                ),
              );
            }),

            32.ph,

            /// Submit Button
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
                  'save_and_continue'.tr(),
                  style: AppStyles.s16SemiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
