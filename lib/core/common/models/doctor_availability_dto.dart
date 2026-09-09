import 'package:doctory/core/enums/week_day.dart';

import 'time_slot_model.dart';

class DoctorAvailabilityDto {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;

  DoctorAvailabilityDto({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.slotDurationMinutes = 30,
  });

  factory DoctorAvailabilityDto.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityDto(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      slotDurationMinutes: (json['slotDurationMinutes'] as num?)?.toInt() ?? 30,
    );
  }

  /// Translation key for the localized day name (e.g. 'sunday').
  /// Falls back to the raw dayOfWeek value when it is not a recognized day.
  String get dayLabelKey => WeekDay.labelKeyFor(dayOfWeek);

  /// Generates time slots for [date] based on this availability entry.
  /// Returns an empty list when [date] is not covered by this entry.
  /// Past slots are skipped when [date] is today.
  List<TimeSlotModel> slotsForDate(DateTime date) {
    final dayKey = (date.weekday % 7).toString();
    if (dayOfWeek != dayKey) return [];

    final startMinutes = _parseMinutesOfDay(startTime);
    final endMinutes = _parseMinutesOfDay(endTime);
    if (startMinutes == null || endMinutes == null) return [];
    if (endMinutes <= startMinutes) return [];

    final isToday = _isSameDay(date, DateTime.now());
    final duration = Duration(minutes: slotDurationMinutes);
    final cursor = DateTime(
      date.year,
      date.month,
      date.day,
      startMinutes ~/ 60,
      startMinutes % 60,
    );
    final endDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      endMinutes ~/ 60,
      endMinutes % 60,
    );
    final slots = <TimeSlotModel>[];
    var index = 0;

    var current = cursor;
    while (current.isBefore(endDateTime)) {
      var slotEnd = current.add(duration);
      if (slotEnd.isAfter(endDateTime)) slotEnd = endDateTime;
      if (slotEnd == current) break;

      if (!isToday || current.isAfter(DateTime.now())) {
        slots.add(
          TimeSlotModel(
            id: '$id-$index',
            startTime: current,
            endTime: slotEnd,
            isAvailable: true,
          ),
        );
      }
      current = slotEnd;
      index++;
    }

    return slots;
  }

  /// Whether this entry's working period for [date] has fully ended at [now].
  /// Returns false when [date] is not covered by this entry.
  bool hasEndedAt(DateTime date, DateTime now) {
    final dayKey = (date.weekday % 7).toString();
    if (dayOfWeek != dayKey) return false;
    final endMinutes = _parseMinutesOfDay(endTime);
    if (endMinutes == null) return false;
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes >= endMinutes;
  }

  static int? _parseMinutesOfDay(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
    };
  }
}
