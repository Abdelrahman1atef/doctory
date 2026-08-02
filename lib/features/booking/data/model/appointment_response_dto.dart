import 'package:doctory/features/booking/domain/enums/appointment_status.dart';

class AppointmentPaymentDto {
  final String? paymentId;
  final double? amount;
  final String? currency;
  final String? paymentStatus;
  final String? paymobRedirectUrl;
  final DateTime? paidAt;

  const AppointmentPaymentDto({
    this.paymentId,
    this.amount,
    this.currency,
    this.paymentStatus,
    this.paymobRedirectUrl,
    this.paidAt,
  });

  factory AppointmentPaymentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentPaymentDto(
      paymentId: json['paymentId']?.toString() ?? json['id']?.toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      paymobRedirectUrl: json['paymobRedirectUrl']?.toString(),
      paidAt: json['paidAt'] != null
          ? DateTime.tryParse(json['paidAt'].toString())
          : json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
    );
  }
}

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
  final String? rejectionReason;
  final String? bookingReference;
  final String? paymentId;
  final double? amount;
  final String? currency;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final String? receiptUrl;
  final AppointmentPaymentDto? payment;

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
    this.rejectionReason,
    this.bookingReference,
    this.paymentId,
    this.amount,
    this.currency,
    this.expiresAt,
    required this.createdAt,
    this.receiptUrl,
    this.payment,
  });

  AppointmentStatus get appointmentStatus => AppointmentStatus.fromValue(status);

  String? get paymobRedirectUrl => payment?.paymobRedirectUrl;

  DateTime? get paidAt => payment?.paidAt;

  String? get paymentStatus => payment?.paymentStatus;

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) {
    final paymentJson = json['payment'];
    final payment = paymentJson is Map<String, dynamic>
        ? AppointmentPaymentDto.fromJson(paymentJson)
        : null;
    return AppointmentResponseDto(
      id: json['id']?.toString() ?? '',
      bookedByUserId: json['bookedByUserId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      doctorName: json['doctorName'] ?? '',
      clinicId: json['clinicId']?.toString() ?? '',
      clinicName: json['clinicName']?.toString(),
      appointmentDate: DateTime.tryParse(
            json['date']?.toString() ?? json['appointmentDate']?.toString() ?? '',
          ) ??
          DateTime.now(),
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
      rejectionReason: json['rejectionReason']?.toString(),
      bookingReference: json['bookingReference']?.toString(),
      paymentId: payment?.paymentId ?? json['paymentId']?.toString(),
      amount: payment?.amount ?? (json['amount'] as num?)?.toDouble(),
      currency: payment?.currency ?? json['currency']?.toString(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      receiptUrl: json['receiptUrl']?.toString(),
      payment: payment,
    );
  }
}
