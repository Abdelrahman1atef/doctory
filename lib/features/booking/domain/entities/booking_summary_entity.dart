import 'package:doctory/core/common/models/time_slot_model.dart';
import '../enums/appointment_type.dart';

class BookingSummaryEntity {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorImageUrl;
  final String clinicId;
  final String? clinicName;
  final DateTime appointmentDate;
  final TimeSlotModel timeSlot;
  final AppointmentType appointmentType;
  final double consultationFee;
  final String currency;
  final String patientName;
  final String patientPhone;

  const BookingSummaryEntity({
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    this.doctorImageUrl,
    required this.clinicId,
    this.clinicName,
    required this.appointmentDate,
    required this.timeSlot,
    required this.appointmentType,
    required this.consultationFee,
    required this.currency,
    required this.patientName,
    required this.patientPhone,
  });
}
