class CreateAppointmentRequest {
  final String doctorId;
  final String clinicId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final int appointmentType; // 1 = InPerson, 2 = Online, 3 = FollowUp
  final String patientFullName;
  final String patientPhoneNumber;
  final String patientAge;
  final int patientGender; // 1 = Male, 2 = Female
  final String complaint;
  final String? chronicDiseases;

  CreateAppointmentRequest({
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

  Map<String, dynamic> toJson() {
    return {
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
}
