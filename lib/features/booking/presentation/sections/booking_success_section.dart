import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_success_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';

/// Section for the success step.
class BookingSuccessSection extends StatelessWidget {
  const BookingSuccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingStates>(
      buildWhen: (prev, curr) =>
          curr is BookingStateUpdated &&
          curr.currentStep == BookingStep.success,
      builder: (context, state) {
        if (state is! BookingStateUpdated ||
            state.selectedDate == null ||
            state.selectedTime == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BookingSuccessCard(
                doctor: state.doctor,
                selectedDate: state.selectedDate!,
                selectedTime: state.selectedTime!,
                bookingRef: state.bookingRef,
              ),
              32.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'success_extra_info'.tr(),
                  style: AppStyles.s14Medium.withColor(AppColors.grey500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
