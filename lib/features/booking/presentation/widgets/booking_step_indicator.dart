import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A segmented progress bar indicator for the booking flow.
class BookingStepIndicator extends StatelessWidget {
  final BookingStep currentStep;

  const BookingStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const int totalSteps = 4;
    final int currentStepIndex = currentStep.index + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Text (Right aligned in RTL)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              LocaleKeys.booking_step_format.tr(
                args: [currentStepIndex.toString(), totalSteps.toString()],
              ),
              style: AppStyles.s14Medium.withColor(AppColors.grey600),
            ),
          ),
          const SizedBox(height: 12),
          // Progress Bar segments
          Row(
            children: List.generate(totalSteps, (index) {
              // In RTL, index 0 is on the right.
              // If currentStepIndex is 1, then the 1st segment (index 0 in RTL) should be active.
              // In Flutter Row with RTL, the first child is on the right.
              final bool isActive = index < currentStepIndex;

              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsetsDirectional.only(
                    end: index == totalSteps - 1 ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.stitchPrimary
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
