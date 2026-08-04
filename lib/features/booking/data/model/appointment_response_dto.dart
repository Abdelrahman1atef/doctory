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
      paymobRedirectUrl:
          json['paymentUrl']?.toString() ?? json['paymobRedirectUrl']?.toString(),
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
  final AppointmentStatus appointmentStatus;
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
    this.appointmentStatus = AppointmentStatus.pending,
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

  /// Raw integer value for backward compat (e.g., sending to API)
  int get status => appointmentStatus.value;

  String? get paymobRedirectUrl => payment?.paymobRedirectUrl;

  DateTime? get paidAt => payment?.paidAt;

  String? get paymentStatus => payment?.paymentStatus;

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) {
    final paymentJson = json['payment'];
    final paymentUrl =
        json['paymentUrl']?.toString() ?? json['paymobRedirectUrl']?.toString();
    final payment = paymentJson is Map<String, dynamic>
        ? AppointmentPaymentDto.fromJson(paymentJson)
        : paymentUrl != null
            ? AppointmentPaymentDto(paymobRedirectUrl: paymentUrl)
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
      appointmentType: _parseInt(json['appointmentType']) ?? 1,
      appointmentStatus: AppointmentStatus.from(json['status']),
      patientFullName: json['patientFullName'] ?? '',
      patientPhoneNumber: json['patientPhoneNumber'] ?? '',
      patientAge: _parseInt(json['patientAge']),
      patientGender: _parseInt(json['patientGender']),
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static int _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'Pending': return 0;
        case 'Confirmed': return 1;
        case 'Cancelled': return 2;
        case 'Completed': return 3;
        case 'Reserved': return 4;
        case 'NoShow': return 5;
        case 'Accepted': return 6;
        case 'Rejected': return 7;
        default: return 0;
      }
    }
    return 0;
  }
}

