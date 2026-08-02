import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_error_banner.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_summary_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBookingSection extends StatelessWidget {
  const ReviewBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData ||
            state.selectedDate == null ||
            state.selectedTime == null) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<BookingCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingSectionHeader(
                title: 'review_booking'.tr(),
                subtitle: 'review_details_before_confirm'.tr(),
              ),
              const SizedBox(height: 20),
              BookingSummaryCard(
                doctor: cubit.doctor,
                selectedDate: state.selectedDate!,
                selectedTime: state.selectedTime!,
                consultationFee: state.reservation?.amount ?? 150.0,
                currency: state.reservation?.currency ?? 'EGP',
                appointmentType: state.appointmentType.value,
                patientName: state.patientName,
              ),
              const SizedBox(height: 24),
              if (state.submissionError != null)
                BookingErrorBanner(message: state.submissionError!),
            ],
          ),
        );
      },
    );
  }
}
