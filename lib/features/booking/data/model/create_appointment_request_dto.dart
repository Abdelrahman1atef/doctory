class CreateAppointmentRequestDto {
  final String doctorId;
  final String clinicId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final int appointmentType;
  final String patientFullName;
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
    'patientAge': patientAge,
    'patientGender': patientGender,
    'complaint': complaint,
    'chronicDiseases': chronicDiseases,
  };
}
