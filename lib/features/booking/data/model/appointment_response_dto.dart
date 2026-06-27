import 'package:doctory/features/booking/domain/enums/appointment_status.dart';

class AppointmentResponseDto {
  final String id;
  final String bookedByUserId;
  final String doctorId;
  final String doctorName;
  final String clinicId;
  final String? clinicName;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final int appointmentType;
  final int status;
  final String patientFullName;
  final String patientPhoneNumber;
  final int? patientAge;
  final int? patientGender;
  final String? complaint;
  final String? chronicDiseases;
  final String? cancellationReason;
  final String? bookingReference;
  final String? paymentId;
  final double? amount;
  final String? currency;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final String? receiptUrl;

  const AppointmentResponseDto({
    required this.id,
    this.bookedByUserId = '',
    required this.doctorId,
    this.doctorName = '',
    required this.clinicId,
    this.clinicName,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.appointmentType,
    this.status = 0,
    this.patientFullName = '',
    this.patientPhoneNumber = '',
    this.patientAge,
    this.patientGender,
    this.complaint,
    this.chronicDiseases,
    this.cancellationReason,
    this.bookingReference,
    this.paymentId,
    this.amount,
    this.currency,
    this.expiresAt,
    required this.createdAt,
    this.receiptUrl,
  });

  AppointmentStatus get appointmentStatus => AppointmentStatus.fromValue(status);

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) =>
      AppointmentResponseDto(
        id: json['id']?.toString() ?? '',
        bookedByUserId: json['bookedByUserId']?.toString() ?? '',
        doctorId: json['doctorId']?.toString() ?? '',
        doctorName: json['doctorName'] ?? '',
        clinicId: json['clinicId']?.toString() ?? '',
        clinicName: json['clinicName']?.toString(),
        appointmentDate: DateTime.parse(json['appointmentDate']),
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        appointmentType: json['appointmentType'] as int? ?? 1,
        status: json['status'] as int? ?? 0,
        patientFullName: json['patientFullName'] ?? '',
        patientPhoneNumber: json['patientPhoneNumber'] ?? '',
        patientAge: json['patientAge'] as int?,
        patientGender: json['patientGender'] as int?,
        complaint: json['complaint']?.toString(),
        chronicDiseases: json['chronicDiseases']?.toString(),
        cancellationReason: json['cancellationReason']?.toString(),
        bookingReference: json['bookingReference']?.toString(),
        paymentId: json['paymentId']?.toString(),
        amount: (json['amount'] as num?)?.toDouble(),
        currency: json['currency']?.toString(),
        expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
        createdAt: DateTime.parse(json['createdAt']),
        receiptUrl: json['receiptUrl']?.toString(),
      );
}
