import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_verification_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationSection extends StatelessWidget {
  const VerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();

        if (state.isSubmitting) {
          return const BookingVerificationLoading();
        }

        if (state.submissionError != null) {
          return BookingVerificationError(
            message: state.submissionError!,
            onRetry: () => context.read<BookingCubit>().verifyPayment(),
          );
        }

        return const BookingVerificationSuccess();
      },
    );
  }
}
