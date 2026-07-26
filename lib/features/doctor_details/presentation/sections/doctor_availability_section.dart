import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorAvailabilitySection extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorAvailabilitySection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (doctor.availabilities != null &&
              doctor.availabilities!.isNotEmpty) ...[
            Text(
              'operating_hours'.tr(),
              style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
            ),
            12.ph,
            ...doctor.availabilities!.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      a.dayOfWeek,
                      style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
                    ),
                    Text(
                      '${_formatTime(a.startTime)} - ${_formatTime(a.endTime)}',
                      style: AppStyles.s14Medium.withColor(AppColors.stitchPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ),
            24.ph,
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  AppRoutes.bookingSelectDate,
                  extra: {
                    'doctor': doctor,
                    'clinicId': doctor.clinicId ?? '',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                foregroundColor: AppColors.stitchSurfaceLowest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text('book_appointment'.tr(), style: AppStyles.s16Bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    return '${parts[0]}:${parts[1]}';
  }
}
