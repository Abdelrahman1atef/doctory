import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/common/widgets/inputs/stitch_upload_field.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class ClinicCompleteProfileWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController clinicNameController;
  final String clinicAddress;
  final double? clinicLat;
  final String? clinicImageFileName;
  final VoidCallback onPickClinicImage;
  final VoidCallback onPickLocation;
  final List<DayHours> dayHours;
  final Future<void> Function(int dayIndex, bool isFrom) onPickTime;
  final void Function(int dayIndex) onToggleClosed;
  final VoidCallback onSubmit;

  const ClinicCompleteProfileWidget({
    super.key,
    required this.formKey,
    required this.clinicNameController,
    required this.clinicAddress,
    required this.clinicLat,
    required this.clinicImageFileName,
    required this.onPickClinicImage,
    required this.onPickLocation,
    required this.dayHours,
    required this.onPickTime,
    required this.onToggleClosed,
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
              context.l10n('complete_profile_title'),
              style: AppStyles.s24Bold.copyWith(color: AppColors.onSurface),
            ),
            8.ph,
            Text(
              context.l10n('complete_profile_subtitle'),
              style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
            ),
            32.ph,

            /// Clinic Image
            StitchUploadField(
              label: context.l10n('clinic_image'),
              fileName: clinicImageFileName,
              hint: context.l10n('upload_file_hint'),
              isRequired: true,
              onPick: onPickClinicImage,
            ),
            20.ph,

            /// Clinic Name
            StitchTextField(
              controller: clinicNameController,
              label: context.l10n('clinic_name_label'),
              hintText: context.l10n('clinic_name_hint'),
              prefixIcon: const Icon(
                Icons.local_hospital_outlined,
                color: AppColors.stitchPrimary,
              ),
            ),
            20.ph,

            /// Clinic Location
            Text(
              context.l10n('clinic_location'),
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
                            : context.l10n('pick_location_hint'),
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

            /// Operating Hours Header
            Text(
              context.l10n('operating_hours'),
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
                  context.l10n('save_and_continue'),
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
