import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_calendar_grid.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_doctor_card.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDateSection extends StatelessWidget {
  const SelectDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final availableDates = List.generate(
      30,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              BookingDoctorCard(doctor: context.read<BookingCubit>().doctor),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BookingSectionHeader(
                  title: 'select_date'.tr(),
                  subtitle: 'choose_available_day'.tr(),
                ),
              ),
              const SizedBox(height: 16),
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
