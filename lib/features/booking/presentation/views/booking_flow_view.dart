import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/presentation/sections/booking_success_section.dart';
import 'package:doctory/features/booking/presentation/sections/confirm_booking_section.dart';
import 'package:doctory/features/booking/presentation/sections/select_date_section.dart';
import 'package:doctory/features/booking/presentation/sections/select_time_section.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_action_button.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_step_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Single view managing the entire booking flow.
class BookingFlowView extends StatelessWidget {
  const BookingFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      appBar: AppBar(
        backgroundColor: AppColors.stitchSurface,
        elevation: 0,
        centerTitle: true,
        leading: BlocBuilder<BookingCubit, BookingStates>(
          builder: (context, state) {
            final cubit = context.read<BookingCubit>();
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.stitchPrimaryContainer,
                size: 20,
              ),
              onPressed: () {
                if (cubit.currentStep == BookingStep.success) {
                  context.pop(); // Return to previous screen if done
                } else if (cubit.currentStep != BookingStep.selectDate) {
                  cubit.previousStep();
                } else {
                  context.pop();
                }
              },
            );
          },
        ),
        title: BlocBuilder<BookingCubit, BookingStates>(
          builder: (context, state) {
            final step = context.read<BookingCubit>().currentStep;
            final title = step == BookingStep.success
                ? 'booking_confirmed'
                : 'book_appointment';
            return Text(
              title.tr(),
              style: AppStyles.s16Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
            );
          },
        ),
      ),
      body: BlocConsumer<BookingCubit, BookingStates>(
        listener: (context, state) {
          if (state is BookingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        buildWhen: (prev, curr) => curr is BookingStateUpdated,
        builder: (context, state) {
          if (state is! BookingStateUpdated)
            return const Center(child: CircularProgressIndicator());

          final cubit = context.read<BookingCubit>();

          return Column(
            children: [
              // Step Indicator
              if (cubit.currentStep != BookingStep.success)
                BookingStepIndicator(currentStep: cubit.currentStep),

              // Dynamic Content Area
              Expanded(
                child: IndexedStack(
                  index: cubit.currentStep.index,
                  children: const [
                    SelectDateSection(),
                    SelectTimeSection(),
                    ConfirmBookingSection(),
                    BookingSuccessSection(),
                  ],
                ),
              ),

              // Bottom Action Button
              _buildBottomAction(context, cubit, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    BookingCubit cubit,
    BookingStateUpdated state,
  ) {
    if (cubit.currentStep == BookingStep.success) {
      return BookingActionButton(
        label: 'done'.tr(),
        onPressed: () => context.pop(),
      );
    }

    String label;
    bool isEnabled = false;

    switch (cubit.currentStep) {
      case BookingStep.selectDate:
        label = 'next'.tr();
        isEnabled = state.selectedDate != null;
        break;
      case BookingStep.selectTime:
        label = 'next'.tr();
        isEnabled = state.selectedTime != null;
        break;
      case BookingStep.confirm:
        label = 'confirm_booking'.tr();
        isEnabled =
            state.patientName.isNotEmpty && state.patientPhone.isNotEmpty;
        break;
      default:
        label = '';
    }

    return BlocBuilder<BookingCubit, BookingStates>(
      builder: (context, blocState) {
        return BookingActionButton(
          label: label,
          isLoading: blocState is BookingSubmitting,
          onPressed: isEnabled
              ? () {
                  if (cubit.currentStep == BookingStep.confirm) {
                    cubit.confirmBooking();
                  } else {
                    cubit.nextStep();
                  }
                }
              : null,
        );
      },
    );
  }
}
