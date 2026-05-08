import 'package:doctory/core/common/models/shared_models.dart';

class BookingMockData {
  /// Consultation fee in SAR
  static const double consultationFee = 150.0;

  /// Currency symbol
  static const String currency = 'SAR';

  static List<DateTime> getAvailableDates() {
    final now = DateTime.now();
    return [
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 3)),
      now.add(const Duration(days: 4)),
      now.add(const Duration(days: 5)),
      now.add(const Duration(days: 7)),
      now.add(const Duration(days: 8)),
      now.add(const Duration(days: 10)),
      now.add(const Duration(days: 12)),
      now.add(const Duration(days: 14)),
    ];
  }

  static List<TimeSlotModel> getTimeSlotsForDate(DateTime date) {
    final isToday =
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    return [
      // Morning slots (8 AM - 12 PM)
      TimeSlotModel(
        id: 's1',
        startTime: date.copyWith(hour: 8, minute: 0),
        endTime: date.copyWith(hour: 8, minute: 30),
        isAvailable: !isToday,
      ),
      TimeSlotModel(
        id: 's2',
        startTime: date.copyWith(hour: 9, minute: 0),
        endTime: date.copyWith(hour: 9, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's3',
        startTime: date.copyWith(hour: 10, minute: 0),
        endTime: date.copyWith(hour: 10, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's4',
        startTime: date.copyWith(hour: 11, minute: 0),
        endTime: date.copyWith(hour: 11, minute: 30),
        isAvailable: false,
      ),
      // Afternoon slots (12 PM - 5 PM)
      TimeSlotModel(
        id: 's5',
        startTime: date.copyWith(hour: 13, minute: 0),
        endTime: date.copyWith(hour: 13, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's6',
        startTime: date.copyWith(hour: 14, minute: 0),
        endTime: date.copyWith(hour: 14, minute: 30),
        isAvailable: false,
      ),
      TimeSlotModel(
        id: 's7',
        startTime: date.copyWith(hour: 15, minute: 30),
        endTime: date.copyWith(hour: 16, minute: 0),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's8',
        startTime: date.copyWith(hour: 16, minute: 30),
        endTime: date.copyWith(hour: 17, minute: 0),
        isAvailable: true,
      ),
      // Evening slots (5 PM+)
      TimeSlotModel(
        id: 's9',
        startTime: date.copyWith(hour: 18, minute: 0),
        endTime: date.copyWith(hour: 18, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's10',
        startTime: date.copyWith(hour: 19, minute: 0),
        endTime: date.copyWith(hour: 19, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's11',
        startTime: date.copyWith(hour: 20, minute: 0),
        endTime: date.copyWith(hour: 20, minute: 30),
        isAvailable: !isToday,
      ),
    ];
  }

  /// Categorize time slots into Morning / Afternoon / Evening
  static Map<String, List<TimeSlotModel>> categorizeSlots(
    List<TimeSlotModel> slots,
  ) {
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
