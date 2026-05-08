import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/data/data_source/booking_mock_data.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_time_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section that handles time slot selection, categorizing by period.
class SelectTimeSection extends StatelessWidget {
  const SelectTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingStates>(
      buildWhen: (prev, curr) => curr is BookingStateUpdated,
      builder: (context, state) {
        if (state is! BookingStateUpdated || state.selectedDate == null) {
          return const SizedBox.shrink();
        }

        final slots = BookingMockData.getTimeSlotsForDate(state.selectedDate!);
        final categorized = BookingMockData.categorizeSlots(slots);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected date header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: AppColors.stitchPrimary,
                    ),
                    8.pw,
                    Text(
                      DateFormat('EEEE, MMM d').format(state.selectedDate!),
                      style: AppStyles.s14Bold.withColor(
                        AppColors.stitchPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              24.ph,
              Text(
                'select_time'.tr(),
                style: AppStyles.s18Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              6.ph,
              Text(
                'choose_preferred_time'.tr(),
                style: AppStyles.s14Medium.withColor(AppColors.grey500),
              ),
              24.ph,
              // Morning
              BookingTimeGroup(
                title: 'morning'.tr(),
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFFFA726),
                slots: categorized['morning'] ?? [],
                selectedSlot: state.selectedTime,
                onSlotSelected: (slot) =>
                    context.read<BookingCubit>().selectTime(slot),
              ),
              if ((categorized['morning'] ?? []).isNotEmpty) 24.ph,
              // Afternoon
              BookingTimeGroup(
                title: 'afternoon'.tr(),
                icon: Icons.wb_cloudy_outlined,
                iconColor: const Color(0xFF42A5F5),
                slots: categorized['afternoon'] ?? [],
                selectedSlot: state.selectedTime,
                onSlotSelected: (slot) =>
                    context.read<BookingCubit>().selectTime(slot),
              ),
              if ((categorized['afternoon'] ?? []).isNotEmpty) 24.ph,
              // Evening
              BookingTimeGroup(
                title: 'evening'.tr(),
                icon: Icons.nights_stay_outlined,
                iconColor: const Color(0xFF7E57C2),
                slots: categorized['evening'] ?? [],
                selectedSlot: state.selectedTime,
                onSlotSelected: (slot) =>
                    context.read<BookingCubit>().selectTime(slot),
              ),
            ],
          ),
        );
      },
    );
  }
}
