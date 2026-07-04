enum RequestStatus { pending, accepted, rejected }

class ReservationRequest {
  final int id;
  final String patientName;
  final String? patientPhone;
  final String requestedDate;
  final String requestedTime;
  final String? reason;
  final RequestStatus status;

  ReservationRequest({
    required this.id,
    required this.patientName,
    this.patientPhone,
    required this.requestedDate,
    required this.requestedTime,
    this.reason,
    required this.status,
  });

  factory ReservationRequest.fromJson(Map<String, dynamic> json) {
    return ReservationRequest(
      id: json['id'] as int,
      patientName: json['patientName'] as String,
      patientPhone: json['patientPhone'] as String?,
      requestedDate: json['requestedDate'] as String,
      requestedTime: json['requestedTime'] as String,
      reason: json['reason'] as String?,
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
    );
  }
}
