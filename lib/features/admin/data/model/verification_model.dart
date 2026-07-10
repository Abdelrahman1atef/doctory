class AdminVerificationModel {
  final String id;
  final String doctorName;
  final String specialty;
  final String degree;
  final String syndicateId;
  final String taxRegistry;
  final String phone;
  final String email;
  final String requestDate;
  final String status;
  final List<String> documents;

  const AdminVerificationModel({
    required this.id,
    this.doctorName = '',
    this.specialty = '',
    this.degree = '',
    this.syndicateId = '',
    this.taxRegistry = '',
    this.phone = '',
    this.email = '',
    this.requestDate = '',
    this.status = 'pending',
    this.documents = const [],
  });

  factory AdminVerificationModel.fromJson(Map<String, dynamic> json) {
    return AdminVerificationModel(
      id: json['id']?.toString() ?? '',
      doctorName: json['doctorName'] ?? '',
      specialty: json['specialty'] ?? '',
      degree: json['degree'] ?? '',
      syndicateId: json['syndicateId'] ?? '',
      taxRegistry: json['taxRegistry'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      requestDate: json['requestDate'] ?? '',
      status: json['status'] ?? 'pending',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
