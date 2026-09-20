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

  /// [doctorId] / [clinicId] are used when the item itself omits them (the
  /// week endpoint carries them once on the envelope, not per window).
  factory AvailabilityDto.fromJson(
    Map<String, dynamic> json, {
    String doctorId = '',
    String clinicId = '',
  }) {
    final itemDoctorId = ParseUtils.ensureString(json['doctorId']);
    final itemClinicId = ParseUtils.ensureString(json['clinicId']);
    // Write responses use `startTime`/`endTime`; the week endpoint nests
    // them as `workingHours: { from, to }`.
    final workingHours = ParseUtils.ensureMap(json['workingHours']);
    return AvailabilityDto(
      id: ParseUtils.ensureString(json['id']),
      doctorId: itemDoctorId.isEmpty ? doctorId : itemDoctorId,
      clinicId: itemClinicId.isEmpty ? clinicId : itemClinicId,
      // The API sends either the 0-6 index or the English name ("Sunday").
      dayOfWeek: WeekDay.fromApi(json['dayOfWeek']?.toString())?.index ??
          ParseUtils.ensureInt(json['dayOfWeek']),
      startTime: ParseUtils.ensureString(json['startTime'] ?? workingHours['from']),
      endTime: ParseUtils.ensureString(json['endTime'] ?? workingHours['to']),
      slotDurationMinutes: ParseUtils.ensureInt(json['slotDurationMinutes']),
    );
  }

  /// Parses the week response: `{ doctorId, clinicId, requestedDate, days: [...] }`.
  /// Also accepts a bare list for forward compatibility.
  static List<AvailabilityDto> listFromJson(dynamic data) {
    if (data is List) {
      return ParseUtils.ensureList(data, AvailabilityDto.fromJson);
    }
    final map = ParseUtils.ensureMap(data);
    final doctorId = ParseUtils.ensureString(map['doctorId']);
    final clinicId = ParseUtils.ensureString(map['clinicId']);
    return ParseUtils.ensureList(
      map['days'],
      (json) => AvailabilityDto.fromJson(json, doctorId: doctorId, clinicId: clinicId),
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

  /// The week endpoint does not return the window id, so such entries
  /// cannot be updated or deleted from the list.
  bool get canDelete => id.isNotEmpty;

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
