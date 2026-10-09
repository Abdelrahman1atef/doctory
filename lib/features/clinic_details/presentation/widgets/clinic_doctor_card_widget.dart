import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/common/widgets/buttons/stitch_button.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_doctor_avatar_widget.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_doctor_info_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Full-width doctor card in the clinic details list with a booking CTA.
class ClinicDoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const ClinicDoctorCardWidget({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.onBook,
  });

  static const double _radius = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(_radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClinicDoctorAvatarWidget(imageUrl: doctor.imageUrl),
                    12.pw,
                    Expanded(child: ClinicDoctorInfoWidget(doctor: doctor)),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.stitchSecondary,
                    ),
                  ],
                ),
                16.ph,
                StitchButton(text: 'book_appointment'.tr(), onPressed: onBook),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
