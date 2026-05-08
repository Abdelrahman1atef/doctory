import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:flutter/material.dart';

/// A horizontal 3-step progress indicator for the booking flow.
class BookingStepIndicator extends StatelessWidget {
  final BookingStep currentStep;

  const BookingStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      BookingStep.selectDate,
      BookingStep.selectTime,
      BookingStep.confirm,
    ];
    final labels = ['Date', 'Time', 'Confirm'];
    final currentIndex = currentStep == BookingStep.success
        ? 3
        : steps.indexOf(currentStep);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          // Even indices = step circles, Odd indices = connecting lines
          if (i.isOdd) {
            final lineIndex = i ~/ 2;
            final isCompleted = lineIndex < currentIndex;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                color: isCompleted
                    ? AppColors.stitchPrimary
                    : AppColors.grey300,
              ),
            );
          }

          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < currentIndex;
          final isActive = stepIndex == currentIndex;

          return _StepCircle(
            label: labels[stepIndex],
            stepNumber: stepIndex + 1,
            isCompleted: isCompleted,
            isActive: isActive,
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String label;
  final int stepNumber;
  final bool isCompleted;
  final bool isActive;

  const _StepCircle({
    required this.label,
    required this.stepNumber,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.success
                : isActive
                ? AppColors.stitchPrimary
                : AppColors.grey200,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.stitchPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '$stepNumber',
                    style: AppStyles.s14Bold.withColor(
                      isActive ? Colors.white : AppColors.grey500,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppStyles.s12Medium.withColor(
            isActive
                ? AppColors.stitchPrimary
                : isCompleted
                ? AppColors.success
                : AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
