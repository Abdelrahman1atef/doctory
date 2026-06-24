import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A single time slot chip with selected/available/unavailable states.
class BookingTimeSlotChip extends StatelessWidget {
  final DateTime startTime;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback? onTap;

  const BookingTimeSlotChip({
    super.key,
    required this.startTime,
    required this.isAvailable,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimary
              : isAvailable
              ? AppColors.stitchSurfaceLowest
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.stitchPrimary
                : isAvailable
                ? AppColors.stitchSurfaceLow
                : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.stitchPrimary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          DateFormat('hh:mm a', context.locale.toLanguageTag()).format(startTime),
          style: AppStyles.s14Medium.withColor(
            isSelected
                ? Colors.white
                : isAvailable
                ? AppColors.stitchPrimaryContainer
                : AppColors.grey400,
          ),
        ),
      ),
    );
  }
}
