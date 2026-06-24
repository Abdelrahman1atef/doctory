import 'package:doctory/core/common/models/time_slot_model.dart';

class AvailableSlotsDto {
  final String doctorId;
  final String clinicId;
  final DateTime date;
  final List<TimeSlotModel> slots;
  final WorkingHoursDto? workingHours;
  final int slotDurationMinutes;

  const AvailableSlotsDto({
    required this.doctorId,
    required this.clinicId,
    required this.date,
    required this.slots,
    this.workingHours,
    this.slotDurationMinutes = 30,
  });

  factory AvailableSlotsDto.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    return AvailableSlotsDto(
      doctorId: json['doctorId']?.toString() ?? '',
      clinicId: json['clinicId']?.toString() ?? '',
      date: date,
      slots: (json['slots'] as List? ?? [])
          .map((s) => TimeSlotModel.fromJson(s, date: date))
          .toList(),
      workingHours: json['workingHours'] != null
          ? WorkingHoursDto.fromJson(json['workingHours'])
          : null,
      slotDurationMinutes: json['slotDurationMinutes'] as int? ?? 30,
    );
  }

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'clinicId': clinicId,
    'date': date.toIso8601String(),
    'slots': slots.map((s) => s.toJson()).toList(),
    'workingHours': workingHours?.toJson(),
    'slotDurationMinutes': slotDurationMinutes,
  };
}

class WorkingHoursDto {
  final String from;
  final String to;

  const WorkingHoursDto({required this.from, required this.to});

  factory WorkingHoursDto.fromJson(Map<String, dynamic> json) => WorkingHoursDto(
    from: json['from']?.toString() ?? '',
    to: json['to']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {'from': from, 'to': to};
}
