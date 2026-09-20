import 'package:doctory/core/enums/week_day.dart';
import 'package:doctory/core/utils/parse_utils.dart';

class AvailabilityDto {
  final String id;
  final String doctorId;
  final String clinicId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;

  const AvailabilityDto({
    required this.id,
    required this.doctorId,
    required this.clinicId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
  });

  factory AvailabilityDto.fromJson(Map<String, dynamic> json) {
    return AvailabilityDto(
      id: ParseUtils.ensureString(json['id']),
      doctorId: ParseUtils.ensureString(json['doctorId']),
      clinicId: ParseUtils.ensureString(json['clinicId']),
      dayOfWeek: ParseUtils.ensureInt(json['dayOfWeek']),
      startTime: ParseUtils.ensureString(json['startTime']),
      endTime: ParseUtils.ensureString(json['endTime']),
      slotDurationMinutes: ParseUtils.ensureInt(json['slotDurationMinutes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'clinicId': clinicId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
    };
  }

  /// Translation key for the localized day name (e.g. 'sunday').
  String get dayLabelKey => WeekDay.labelKeyFor(dayOfWeek.toString());

  /// `HH:mm` for display — the API returns `HH:mm:ss`.
  String get startTimeDisplay => _hhmm(startTime);
  String get endTimeDisplay => _hhmm(endTime);

  static String _hhmm(String time) {
    final parts = time.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
  }
}
