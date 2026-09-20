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

  static List<AvailabilityDto> get mock => List.generate(
        7,
        (index) => AvailabilityDto(
          id: index.toString(),
          doctorId: 'doc-123',
          clinicId: 'clinic-123',
          dayOfWeek: index,
          startTime: '09:00',
          endTime: '17:00',
          slotDurationMinutes: 30,
        ),
      );
}
