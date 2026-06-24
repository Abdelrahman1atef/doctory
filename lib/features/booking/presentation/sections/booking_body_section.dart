import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/domain/enums/booking_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/extensions.dart';
import 'booking_app_bar_section.dart';
import 'appointment_type_section.dart';
import 'select_date_section.dart';
import 'select_time_section.dart';
import 'patient_info_section.dart';
import 'review_booking_section.dart';
import 'payment_section.dart';
import 'verification_section.dart';
import 'booking_success_section.dart';

class BookingBodySection extends StatelessWidget {
  const BookingBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (prev, curr) =>
          curr is BookingData && curr.submissionError != null &&
          (prev is! BookingData || prev.submissionError != curr.submissionError),
      listener: (context, state) {
        if (state is BookingData && state.submissionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submissionError!)),
          );
        }
      },
      child: BlocBuilder<BookingCubit, BookingState>(
        buildWhen: (prev, curr) => curr is BookingData,
        builder: (context, state) {
          if (state is! BookingData) {
            return const Center(child: CircularProgressIndicator());
          }

          final step = state.currentStep;

          return Column(
            children: [
              if (step != BookingStep.success)
                const BookingAppBarSection(),
              Expanded(
                child: IndexedStack(
                  index: step.index,
                  children: const [

                    AppointmentTypeSection(),
                    SelectDateSection(),
                    SelectTimeSection(),
                    PatientInfoSection(),
                    ReviewBookingSection(),
                    PaymentSection(),
                    VerificationSection(),
                    BookingSuccessSection(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
