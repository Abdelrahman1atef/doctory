import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/common/models/time_slot_model.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
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
      builder: (context, state) {
        if (state is BookingSlotsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BookingSlotsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: AppStyles.s14Medium.withColor(AppColors.error)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final bookingState = context.read<BookingCubit>().state;
                    if (bookingState is BookingStateUpdated && bookingState.selectedDate != null) {
                      context.read<BookingCubit>().fetchAvailableSlots(bookingState.selectedDate!);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! BookingStateUpdated || state.selectedDate == null) {
          return const SizedBox.shrink();
        }

        final slots = state.availableSlots ?? [];
        if (slots.isEmpty) {
          return Center(
            child: Text(
              'no_slots_available'.tr(),
              style: AppStyles.s14Medium.withColor(AppColors.grey500),
            ),
          );
        }

        final categorized = _categorizeSlots(slots);

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
              if ((categorized['morning'] ?? []).isNotEmpty) ...[
                BookingTimeGroup(
                  title: 'morning'.tr(),
                  icon: Icons.wb_sunny_outlined,
                  iconColor: const Color(0xFFFFA726),
                  slots: categorized['morning'] ?? [],
                  selectedSlot: state.selectedTime,
                  onSlotSelected: (slot) =>
                      context.read<BookingCubit>().selectTime(slot),
                ),
                24.ph,
              ],
              // Afternoon
              if ((categorized['afternoon'] ?? []).isNotEmpty) ...[
                BookingTimeGroup(
                  title: 'afternoon'.tr(),
                  icon: Icons.wb_cloudy_outlined,
                  iconColor: const Color(0xFF42A5F5),
                  slots: categorized['afternoon'] ?? [],
                  selectedSlot: state.selectedTime,
                  onSlotSelected: (slot) =>
                      context.read<BookingCubit>().selectTime(slot),
                ),
                24.ph,
              ],
              // Evening
              if ((categorized['evening'] ?? []).isNotEmpty) ...[
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
            ],
          ),
        );
      },
    );
  }

  Map<String, List<TimeSlotModel>> _categorizeSlots(List<TimeSlotModel> slots) {
    final morning = <TimeSlotModel>[];
    final afternoon = <TimeSlotModel>[];
    final evening = <TimeSlotModel>[];

    for (var slot in slots) {
      final hour = slot.startTime.hour;
      if (hour < 12) {
        morning.add(slot);
      } else if (hour < 17) {
        afternoon.add(slot);
      } else {
        evening.add(slot);
      }
    }

    return {
      'morning': morning,
      'afternoon': afternoon,
      'evening': evening,
    };
  }
}
