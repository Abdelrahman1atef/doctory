import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/domain/enums/booking_step.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_success_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingSuccessSection extends StatelessWidget {
  const BookingSuccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) =>
          curr is BookingData && curr.currentStep == BookingStep.success,
      builder: (context, state) {
        if (state is! BookingData ||
            state.selectedDate == null ||
            state.selectedTime == null) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<BookingCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BookingSuccessCard(
                doctor: cubit.doctor,
                selectedDate: state.selectedDate!,
                selectedTime: state.selectedTime!,
                bookingRef: state.appointment?.bookingReference ??
                    state.appointment?.id,
                appointmentType: state.appointmentType,
                patientName: state.patientName,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'booking_submitted_waiting'.tr(),
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
