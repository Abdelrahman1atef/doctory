class CreateAppointmentRequestDto {
  final String doctorId;
  final String clinicId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final int appointmentType;
  final String patientFullName;
  final String patientPhoneNumber;
  final String patientAge;
  final int patientGender;
  final String complaint;
  final String? chronicDiseases;

  const CreateAppointmentRequestDto({
    required this.doctorId,
    required this.clinicId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.appointmentType,
    required this.patientFullName,
    required this.patientPhoneNumber,
    required this.patientAge,
    required this.patientGender,
    required this.complaint,
    this.chronicDiseases,
  });

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'clinicId': clinicId,
    'appointmentDate': appointmentDate.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'appointmentType': appointmentType,
    'patientFullName': patientFullName,
    'patientPhoneNumber': patientPhoneNumber,
    'patientAge': patientAge,
    'patientGender': patientGender,
    'complaint': complaint,
    'chronicDiseases': chronicDiseases,
  };
}

class CreateReservationResponseDto {
  final String reservationId;
  final DateTime expiresAt;
  final String status;
  final double amount;
  final String currency;

  const CreateReservationResponseDto({
    required this.reservationId,
    required this.expiresAt,
    required this.status,
    required this.amount,
    required this.currency,
  });

  factory CreateReservationResponseDto.fromJson(Map<String, dynamic> json) =>
      CreateReservationResponseDto(
        reservationId: json['reservationId']?.toString() ?? '',
        expiresAt: DateTime.parse(json['expiresAt']),
        status: json['status'] ?? 'pending',
        amount: (json['amount'] ?? 0).toDouble(),
        currency: json['currency'] ?? 'SAR',
      );
}
