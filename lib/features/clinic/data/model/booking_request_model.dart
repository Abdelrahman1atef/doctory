enum BookingStatus { pending, accepted, rejected }

enum AppointmentType { inPerson, online, followUp }

class BookingRequestModel {
  final int id;
  final String patientName;
  final String? patientPhone;
  final int? patientAge;
  final String clinicName;
  final String? doctorName;
  final String requestedDate;
  final String requestedTime;
  final String? reason;
  final AppointmentType appointmentType;
  final BookingStatus status;
  final String createdAt;

  BookingRequestModel({
    required this.id,
    required this.patientName,
    this.patientPhone,
    this.patientAge,
    required this.clinicName,
    this.doctorName,
    required this.requestedDate,
    required this.requestedTime,
    this.reason,
    this.appointmentType = AppointmentType.inPerson,
    required this.status,
    required this.createdAt,
  });

  static List<BookingRequestModel> mockList() {
    return [
      BookingRequestModel(
        id: 1,
        patientName: 'Sulaiman Ahmed',
        patientPhone: '0551234567',
        patientAge: 34,
        clinicName: 'Cardiology Clinic',
        doctorName: 'Dr. Khalid',
        requestedDate: '2026-07-04',
        requestedTime: '10:30 AM',
        reason: 'Chest pain for the past 3 days',
        appointmentType: AppointmentType.inPerson,
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
      BookingRequestModel(
        id: 2,
        patientName: 'Huda Omar',
        patientPhone: '0552345678',
        patientAge: 28,
        clinicName: 'Neurology Clinic',
        doctorName: 'Dr. Fatima',
        requestedDate: '2026-07-04',
        requestedTime: '02:00 PM',
        reason: null,
        appointmentType: AppointmentType.followUp,
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
      BookingRequestModel(
        id: 3,
        patientName: 'Mariam Al-Saud',
        patientPhone: '0553456789',
        patientAge: 45,
        clinicName: 'Dermatology Center',
        doctorName: 'Dr. Laila',
        requestedDate: '2026-07-05',
        requestedTime: '11:00 AM',
        reason: 'Skin rash and itching',
        appointmentType: AppointmentType.online,
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
      BookingRequestModel(
        id: 4,
        patientName: 'Faisal Al-Rashid',
        patientPhone: '0554567890',
        patientAge: 52,
        clinicName: 'Orthopedic Clinic',
        doctorName: 'Dr. Ahmed',
        requestedDate: '2026-07-05',
        requestedTime: '09:00 AM',
        reason: 'Knee pain - follow up after surgery',
        appointmentType: AppointmentType.followUp,
        status: BookingStatus.pending,
        createdAt: '2026-07-03',
      ),
      BookingRequestModel(
        id: 5,
        patientName: 'Nora Al-Abdulkarim',
        patientPhone: '0555678901',
        patientAge: 31,
        clinicName: 'General Clinic',
        doctorName: 'Dr. Hassan',
        requestedDate: '2026-07-06',
        requestedTime: '04:30 PM',
        reason: null,
        appointmentType: AppointmentType.inPerson,
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
    ];
  }

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['id'] as int,
      patientName: json['patientName'] as String,
      patientPhone: json['patientPhone'] as String?,
      patientAge: json['patientAge'] as int?,
      clinicName: json['clinicName'] as String,
      doctorName: json['doctorName'] as String?,
      requestedDate: json['requestedDate'] as String,
      requestedTime: json['requestedTime'] as String,
      reason: json['reason'] as String?,
      appointmentType: AppointmentType.values.firstWhere(
        (e) => e.name == json['appointmentType'],
        orElse: () => AppointmentType.inPerson,
      ),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'patientAge': patientAge,
      'clinicName': clinicName,
      'doctorName': doctorName,
      'requestedDate': requestedDate,
      'requestedTime': requestedTime,
      'reason': reason,
      'appointmentType': appointmentType.name,
      'status': status.name,
      'createdAt': createdAt,
    };
  }
}
