enum PendingClinicStatus { pending, approved, rejected, paid }

class AdminPendingClinicModel {
  final String id;
  final String clinicName;
  final String doctorName;
  final String email;
  final String package;
  final String submittedAt;
  final int documentsCount;
  final PendingClinicStatus status;
  final String? notes;

  const AdminPendingClinicModel({
    required this.id,
    required this.clinicName,
    this.doctorName = '',
    this.email = '',
    this.package = '',
    this.submittedAt = '',
    this.documentsCount = 0,
    this.status = PendingClinicStatus.pending,
    this.notes,
  });

  factory AdminPendingClinicModel.fromJson(Map<String, dynamic> json) {
    return AdminPendingClinicModel(
      id: json['id']?.toString() ?? '',
      clinicName: json['clinicName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      email: json['email'] ?? '',
      package: json['package'] ?? '',
      submittedAt: json['submittedAt'] ?? '',
      documentsCount: json['documentsCount'] ?? 0,
      status: _parseStatus(json['status']),
      notes: json['notes'],
    );
  }

  static PendingClinicStatus _parseStatus(dynamic value) {
    if (value == null) return PendingClinicStatus.pending;
    switch (value.toString().toLowerCase()) {
      case 'approved':
        return PendingClinicStatus.approved;
      case 'rejected':
        return PendingClinicStatus.rejected;
      case 'paid':
        return PendingClinicStatus.paid;
      default:
        return PendingClinicStatus.pending;
    }
  }

  AdminPendingClinicModel copyWith({
    PendingClinicStatus? status,
    String? notes,
  }) {
    return AdminPendingClinicModel(
      id: id,
      clinicName: clinicName,
      doctorName: doctorName,
      email: email,
      package: package,
      submittedAt: submittedAt,
      documentsCount: documentsCount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
