class AppointmentResponseDto {
  final String id;
  final String doctorId;
  final String doctorName;
  final String clinicId;
  final String? clinicName;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final int appointmentType;
  final String patientFullName;
  final String patientPhoneNumber;
  final String status;
  final String? bookingRef;
  final String? paymentId;
  final double? amount;
  final String? currency;
  final DateTime createdAt;
  final String? receiptUrl;

  const AppointmentResponseDto({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.clinicId,
    this.clinicName,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.appointmentType,
    required this.patientFullName,
    required this.patientPhoneNumber,
    required this.status,
    this.bookingRef,
    this.paymentId,
    this.amount,
    this.currency,
    required this.createdAt,
    this.receiptUrl,
  });

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) =>
      AppointmentResponseDto(
        id: json['id']?.toString() ?? '',
        doctorId: json['doctorId']?.toString() ?? '',
        doctorName: json['doctorName'] ?? '',
        clinicId: json['clinicId']?.toString() ?? '',
        clinicName: json['clinicName']?.toString(),
        appointmentDate: DateTime.parse(json['appointmentDate']),
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        appointmentType: json['appointmentType'] as int? ?? 1,
        patientFullName: json['patientFullName'] ?? '',
        patientPhoneNumber: json['patientPhoneNumber'] ?? '',
        status: json['status'] ?? 'pending',
        bookingRef: json['bookingRef']?.toString(),
        paymentId: json['paymentId']?.toString(),
        amount: (json['amount'] as num?)?.toDouble(),
        currency: json['currency']?.toString(),
        createdAt: DateTime.parse(json['createdAt']),
        receiptUrl: json['receiptUrl']?.toString(),
      );
}
