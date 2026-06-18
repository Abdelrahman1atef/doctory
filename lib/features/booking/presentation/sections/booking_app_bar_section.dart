import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingAppBarSection extends StatelessWidget {
  const BookingAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();
        return BookingStepIndicator(currentStep: state.currentStep);
      },
    );
  }
}
