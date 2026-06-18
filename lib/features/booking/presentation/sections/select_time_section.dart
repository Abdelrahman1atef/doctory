import 'package:doctory/core/common/models/time_slot_model.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_date_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_slots_error_widget.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_time_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTimeSection extends StatelessWidget {
  const SelectTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();

        if (state.isSlotsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.slotsError != null) {
          return BookingSlotsErrorWidget(
            message: state.slotsError!,
            onRetry: () => context.read<BookingCubit>().retrySlotFetch(),
          );
        }

        final slots = state.availableSlots ?? [];
        if (slots.isEmpty) {
          return Center(
            child: Text('no_slots_available'.tr()),
          );
        }

        final categorized = _categorizeSlots(slots);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingDateHeader(
                formattedDate: DateFormat('EEEE, MMM d').format(state.selectedDate!),
              ),
              const SizedBox(height: 24),
              BookingSectionHeader(
                title: 'select_time'.tr(),
                subtitle: 'choose_preferred_time'.tr(),
              ),
              const SizedBox(height: 24),
              if ((categorized['morning'] ?? []).isNotEmpty) ...[
                BookingTimeGroup(
                  title: 'morning'.tr(),
                  icon: Icons.wb_sunny_outlined,
                  iconColor: const Color(0xFFFFA726),
                  slots: categorized['morning'] ?? [],
                  selectedSlot: state.selectedTime,
                  onSlotSelected: (slot) => context.read<BookingCubit>().selectTime(slot),
                ),
                const SizedBox(height: 24),
              ],
              if ((categorized['afternoon'] ?? []).isNotEmpty) ...[
                BookingTimeGroup(
                  title: 'afternoon'.tr(),
                  icon: Icons.wb_cloudy_outlined,
                  iconColor: const Color(0xFF42A5F5),
                  slots: categorized['afternoon'] ?? [],
                  selectedSlot: state.selectedTime,
                  onSlotSelected: (slot) => context.read<BookingCubit>().selectTime(slot),
                ),
                const SizedBox(height: 24),
              ],
              if ((categorized['evening'] ?? []).isNotEmpty) ...[
                BookingTimeGroup(
                  title: 'evening'.tr(),
                  icon: Icons.nights_stay_outlined,
                  iconColor: const Color(0xFF7E57C2),
                  slots: categorized['evening'] ?? [],
                  selectedSlot: state.selectedTime,
                  onSlotSelected: (slot) => context.read<BookingCubit>().selectTime(slot),
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

    for (final slot in slots) {
      final hour = slot.startTime.hour;
      if (hour < 12) {
        morning.add(slot);
      } else if (hour < 17) {
        afternoon.add(slot);
      } else {
        evening.add(slot);
      }
    }

    return {'morning': morning, 'afternoon': afternoon, 'evening': evening};
  }
}
