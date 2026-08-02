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
                      a.dayLabelKey.tr(),
                      style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
                    ),
                    Text(
                      '${_formatTime(a.startTime, context.locale.toLanguageTag())} - ${_formatTime(a.endTime, context.locale.toLanguageTag())}',
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

  String _formatTime(String time, String locale) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final dateTime = DateTime(2000, 1, 1, hour, minute);
    // 'en' keeps digits in Latin script (0-9); period follows app locale
    final timePart = DateFormat('h:mm', 'en').format(dateTime);
    final period = DateFormat('a', locale).format(dateTime);
    return '$timePart $period';
  }
}
