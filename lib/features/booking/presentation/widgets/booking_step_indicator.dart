import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/domain/enums/booking_step.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class _StepGroup {
  final String labelKey;
  final Set<BookingStep> steps;
  const _StepGroup(this.labelKey, this.steps);
}

class BookingStepIndicator extends StatelessWidget {
  final BookingStep currentStep;

  const BookingStepIndicator({super.key, required this.currentStep});

  static const _stepGroups = [
    _StepGroup('appointment', {BookingStep.appointmentType, BookingStep.selectDate}),
    _StepGroup('details', {BookingStep.selectTime, BookingStep.patientInfo}),
    _StepGroup('review_step', {BookingStep.reviewBooking, BookingStep.payment}),
    _StepGroup('confirmation', {BookingStep.verification, BookingStep.success}),
  ];

  int get _currentGroupIndex {
    for (int i = 0; i < _stepGroups.length; i++) {
      if (_stepGroups[i].steps.contains(currentStep)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIdx = _currentGroupIndex;
    final totalSteps = _stepGroups.length;

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
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                text: 'booking_step_format'.tr(args: [
                  (currentIdx + 1).toString(),
                  totalSteps.toString(),
                ]),
                style: AppStyles.s14Medium.withColor(AppColors.grey600),
                children: [
                  TextSpan(
                    text: ': ${_stepGroups[currentIdx].labelKey.tr()}',
                    style: AppStyles.s14Bold.withColor(AppColors.stitchPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentIdx;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsetsDirectional.only(
                    end: index == totalSteps - 1 ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.stitchPrimary : AppColors.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index == currentIdx;
              return Expanded(
                child: Text(
                  _stepGroups[index].labelKey.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyles.s12Medium.withColor(
                    isActive ? AppColors.stitchPrimary : AppColors.grey400,
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
