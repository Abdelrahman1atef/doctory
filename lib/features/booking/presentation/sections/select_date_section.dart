import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_calendar_grid.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_doctor_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section that handles date selection logic and bridges cubit with widgets.
class SelectDateSection extends StatelessWidget {
  const SelectDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate dates for the next 30 days as available
    final availableDates = List.generate(30, (index) => DateTime.now().add(Duration(days: index)));

    return BlocBuilder<BookingCubit, BookingStates>(
      buildWhen: (prev, curr) => curr is BookingStateUpdated,
      builder: (context, state) {
        if (state is! BookingStateUpdated) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.ph,
              BookingDoctorCard(doctor: state.doctor),
              24.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_date'.tr(),
                      style: AppStyles.s18Bold.withColor(
                        AppColors.stitchPrimaryContainer,
                      ),
                    ),
                    6.ph,
                    Text(
                      'choose_available_day'.tr(),
                      style: AppStyles.s14Medium.withColor(AppColors.grey500),
                    ),
                  ],
                ),
              ),
              16.ph,
              BookingCalendarGrid(
                availableDates: availableDates,
                selectedDate: state.selectedDate,
                onDateSelected: (date) {
                  context.read<BookingCubit>().selectDate(date);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
