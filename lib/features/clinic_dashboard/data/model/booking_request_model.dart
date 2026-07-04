enum BookingStatus { pending, accepted, rejected }

class BookingRequestModel {
  final int id;
  final String patientName;
  final String clinicName;
  final String preferredTime;
  final BookingStatus status;
  final String createdAt;

  BookingRequestModel({
    required this.id,
    required this.patientName,
    required this.clinicName,
    required this.preferredTime,
    required this.status,
    required this.createdAt,
  });

  static List<BookingRequestModel> mockList() {
    return [
      BookingRequestModel(
        id: 1,
        patientName: 'Sulaiman Ahmed',
        clinicName: 'Cardiology Clinic',
        preferredTime: '10:30 AM',
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
      BookingRequestModel(
        id: 2,
        patientName: 'Huda Omar',
        clinicName: 'Neurology Clinic',
        preferredTime: '02:00 PM',
        status: BookingStatus.pending,
        createdAt: '2026-07-04',
      ),
    ];
  }

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['id'] as int,
      patientName: json['patientName'] as String,
      clinicName: json['clinicName'] as String,
      preferredTime: json['preferredTime'] as String,
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
      'clinicName': clinicName,
      'preferredTime': preferredTime,
      'status': status.name,
      'createdAt': createdAt,
    };
  }
}
