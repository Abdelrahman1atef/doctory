import 'package:doctory/core/common/models/time_slot_model.dart';

class BookingAvailableSlotsModel {
  final String doctorId;
  final String clinicId;
  final DateTime date;
  final List<TimeSlotModel> slots;
  final WorkingHoursModel? workingHours;
  final int slotDurationMinutes;

  BookingAvailableSlotsModel({
    required this.doctorId,
    required this.clinicId,
    required this.date,
    required this.slots,
    this.workingHours,
    this.slotDurationMinutes = 30,
  });

  factory BookingAvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    return BookingAvailableSlotsModel(
      doctorId: json['doctorId']?.toString() ?? '',
      clinicId: json['clinicId']?.toString() ?? '',
      date: DateTime.parse(json['date']),
      slots: (json['slots'] as List? ?? [])
          .map((s) => TimeSlotModel.fromJson(s))
          .toList(),
      workingHours: json['workingHours'] != null
          ? WorkingHoursModel.fromJson(json['workingHours'])
          : null,
      slotDurationMinutes: json['slotDurationMinutes'] as int? ?? 30,
    );
  }
}

class WorkingHoursModel {
  final String from;
  final String to;

  WorkingHoursModel({required this.from, required this.to});

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}
