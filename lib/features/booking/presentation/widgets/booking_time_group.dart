import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_time_slot_chip.dart';
import 'package:flutter/material.dart';

/// A group of time slots under a category label (Morning/Afternoon/Evening).
class BookingTimeGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<TimeSlotModel> slots;
  final TimeSlotModel? selectedSlot;
  final ValueChanged<TimeSlotModel> onSlotSelected;

  const BookingTimeGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            8.pw,
            Text(
              title,
              style: AppStyles.s14Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
            ),
            8.pw,
            Text(
              '(${slots.where((s) => s.isAvailable).length} available)',
              style: AppStyles.s12Medium.withColor(AppColors.grey500),
            ),
          ],
        ),
        12.ph,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            return BookingTimeSlotChip(
              startTime: slot.startTime,
              isAvailable: slot.isAvailable,
              isSelected: selectedSlot?.id == slot.id,
              onTap: () => onSlotSelected(slot),
            );
          }).toList(),
        ),
      ],
    );
  }
}
