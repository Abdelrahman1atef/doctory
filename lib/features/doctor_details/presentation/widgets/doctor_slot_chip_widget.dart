import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DoctorSlotChipWidget extends StatelessWidget {
  final TimeSlotModel slot;

  const DoctorSlotChipWidget({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: slot.isAvailable
            ? AppColors.stitchSurfaceLowest
            : AppColors.stitchSurfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: slot.isAvailable
              ? AppColors.stitchPrimaryContainer.withValues(alpha: 0.3)
              : AppColors.stitchSurfaceLow,
        ),
      ),
      child: Text(
        DateFormat('hh:mm a').format(slot.startTime),
        style: AppStyles.s14Medium.withColor(
          slot.isAvailable
              ? AppColors.stitchPrimaryContainer
              : AppColors.stitchSecondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
