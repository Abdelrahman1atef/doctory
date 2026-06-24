import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingAppBarSection extends StatelessWidget {
  const BookingAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16).copyWith(top: MediaQuery.paddingOf(context).top+20),
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
            child: Row(
              children: [
                SizedBox(width: 70,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: AppColors.stitchPrimaryContainer,
                    onPressed: () => context.pop(),
                  ),
                ),
                Expanded(
                  child: BookingStepIndicator(currentStep: state.currentStep),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        );
      },
    );
  }
}
