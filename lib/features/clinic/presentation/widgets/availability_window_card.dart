import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// One working-hours window of a doctor (day, time range, slot length).
class AvailabilityWindowCard extends StatelessWidget {
  final AvailabilityDto window;
  final VoidCallback? onDelete;

  const AvailabilityWindowCard({
    super.key,
    required this.window,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
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
            child: const Icon(
              Icons.schedule_outlined,
              color: AppColors.stitchPrimary,
              size: 26,
            ),
          ),
          14.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  window.dayLabelKey.tr(),
                  style: AppStyles.s16Bold.copyWith(color: AppColors.onSurface),
                ),
                4.ph,
                Text(
                  '${window.startTimeDisplay} - ${window.endTimeDisplay}',
                  style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
                ),
                2.ph,
                Text(
                  '${window.slotDurationMinutes} ${LocaleKeys.minutes_suffix.tr()} / ${LocaleKeys.slot.tr()}',
                  style: AppStyles.s12Medium.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: LocaleKeys.delete.tr(),
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
