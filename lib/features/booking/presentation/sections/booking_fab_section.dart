import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/domain/enums/booking_step.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingFabSection extends StatelessWidget {
  const BookingFabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();
        final cubit = context.read<BookingCubit>();
        final s = state;
        final step = s.currentStep;

        if (step == BookingStep.success) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.stitchSurfaceLowest,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: BookingActionButton(
                label: 'back_to_clinic'.tr(),
                onPressed: () => _returnToClinicDetails(context),
              ),
            ),
          );
        }

        final showPrevious = step != BookingStep.appointmentType;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceLowest,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (showPrevious)
                  SizedBox(
                    width: 130,
                    child: BookingActionButton(
                      label: 'previous'.tr(),
                      onPressed: () => cubit.previousStep(),
                      outlined: true,
                    ),
                  ),
                if (showPrevious) const SizedBox(width: 12),
                Expanded(
                  child: BookingActionButton(
                    label: _buttonLabel(step),
                    onPressed: _canProceed(step, s) && !s.isSubmitting
                        ? () => _onAction(context, cubit, step)
                        : null,
                    isLoading: s.isSubmitting,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _canProceed(BookingStep step, BookingData s) {
    switch (step) {
      case BookingStep.appointmentType:
        return true;
      case BookingStep.selectDate:
        return s.selectedDate != null;
      case BookingStep.selectTime:
        return s.selectedTime != null;
      case BookingStep.patientInfo:
        return s.patientName.isNotEmpty && s.complaint.isNotEmpty;
      case BookingStep.reviewBooking:
        return true;
      case BookingStep.success:
        return false;
    }
  }

  String _buttonLabel(BookingStep step) {
    switch (step) {
      case BookingStep.appointmentType:
      case BookingStep.selectDate:
      case BookingStep.selectTime:
      case BookingStep.patientInfo:
        return 'next'.tr();
      case BookingStep.reviewBooking:
        return 'confirm_booking'.tr();
      case BookingStep.success:
        return '';
    }
  }

  void _returnToClinicDetails(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _onAction(BuildContext context, BookingCubit cubit, BookingStep step) async {
    switch (step) {
      case BookingStep.appointmentType:
      case BookingStep.selectDate:
      case BookingStep.selectTime:
      case BookingStep.patientInfo:
        cubit.nextStep();
        break;
      case BookingStep.reviewBooking:
        cubit.submitBooking();
        break;
      case BookingStep.success:
        break;
    }
  }
}
