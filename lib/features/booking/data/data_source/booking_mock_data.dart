import 'package:doctory/core/common/models/shared_models.dart';

class BookingMockData {
  static List<DateTime> getAvailableDates() {
    final now = DateTime.now();
    return [
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 3)),
      now.add(const Duration(days: 4)),
      now.add(const Duration(days: 5)),
      now.add(const Duration(days: 7)),
    ];
  }

  static List<TimeSlotModel> getTimeSlotsForDate(DateTime date) {
    // Generate some mock slots
    final isToday = date.day == DateTime.now().day;

    return [
      TimeSlotModel(
        id: 's1',
        startTime: date.copyWith(hour: 9, minute: 0),
        endTime: date.copyWith(hour: 9, minute: 30),
        isAvailable: !isToday,
      ),
      TimeSlotModel(
        id: 's2',
        startTime: date.copyWith(hour: 10, minute: 0),
        endTime: date.copyWith(hour: 10, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's3',
        startTime: date.copyWith(hour: 11, minute: 0),
        endTime: date.copyWith(hour: 11, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's4',
        startTime: date.copyWith(hour: 13, minute: 0),
        endTime: date.copyWith(hour: 13, minute: 30),
        isAvailable: false,
      ),
      TimeSlotModel(
        id: 's5',
        startTime: date.copyWith(hour: 14, minute: 0),
        endTime: date.copyWith(hour: 14, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's6',
        startTime: date.copyWith(hour: 18, minute: 0),
        endTime: date.copyWith(hour: 18, minute: 30),
        isAvailable: true,
      ),
      TimeSlotModel(
        id: 's7',
        startTime: date.copyWith(hour: 19, minute: 0),
        endTime: date.copyWith(hour: 19, minute: 30),
        isAvailable: true,
      ),
    ];
  }
}
