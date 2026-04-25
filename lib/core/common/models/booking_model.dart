import 'clinic_model.dart';
import 'doctor_model.dart';
import 'time_slot_model.dart';

class BookingModel {
  final String id;
  final ClinicModel clinic;
  final DoctorModel doctor;
  final DateTime date;
  final TimeSlotModel timeSlot;
  final String patientName;
  final String patientPhone;
  final String? notes;
  final String status; // 'pending', 'confirmed', 'cancelled'

  BookingModel({
    required this.id,
    required this.clinic,
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.patientName,
    required this.patientPhone,
    this.notes,
    this.status = 'pending',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      clinic: ClinicModel.fromJson(json['clinic']),
      doctor: DoctorModel.fromJson(json['doctor']),
      date: DateTime.parse(json['date']),
      timeSlot: TimeSlotModel.fromJson(json['timeSlot']),
      patientName: json['patientName'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      notes: json['notes'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic': clinic.toJson(),
      'doctor': doctor.toJson(),
      'date': date.toIso8601String(),
      'timeSlot': timeSlot.toJson(),
      'patientName': patientName,
      'patientPhone': patientPhone,
      'notes': notes,
      'status': status,
    };
  }
}
