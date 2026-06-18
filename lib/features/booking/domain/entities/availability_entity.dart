import 'package:doctory/core/common/models/time_slot_model.dart';

class AvailabilityEntity {
  final String doctorId;
  final DateTime date;
  final List<TimeSlotModel> slots;
  final String? workingHoursFrom;
  final String? workingHoursTo;
  final int slotDurationMinutes;

  const AvailabilityEntity({
    required this.doctorId,
    required this.date,
    required this.slots,
    this.workingHoursFrom,
    this.workingHoursTo,
    this.slotDurationMinutes = 30,
  });

  List<TimeSlotModel> get availableSlots => slots.where((s) => s.isAvailable).toList();
  bool get hasAvailability => availableSlots.isNotEmpty;
}
