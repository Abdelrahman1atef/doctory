enum DoctorEmploymentType { freelance, ownClinic, inCenter }

class AdminDoctorModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String specialty;
  final String degree;
  final DoctorEmploymentType employmentType;
  final String? clinicId;
  final String? clinicName;
  final bool isActive;

  const AdminDoctorModel({
    required this.id,
    required this.name,
    this.phone = '',
    this.email = '',
    this.specialty = '',
    this.degree = '',
    this.employmentType = DoctorEmploymentType.inCenter,
    this.clinicId,
    this.clinicName,
    this.isActive = true,
  });

  factory AdminDoctorModel.fromJson(Map<String, dynamic> json) {
    return AdminDoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      specialty: json['specialty'] ?? '',
      degree: json['degree'] ?? '',
      employmentType: _parseType(json['employmentType']),
      clinicId: json['clinicId']?.toString(),
      clinicName: json['clinicName'],
      isActive: json['isActive'] ?? true,
    );
  }

  static DoctorEmploymentType _parseType(dynamic value) {
    if (value == null) return DoctorEmploymentType.inCenter;
    switch (value.toString().toLowerCase()) {
      case 'freelance':
        return DoctorEmploymentType.freelance;
      case 'ownclinic':
      case 'own_clinic':
        return DoctorEmploymentType.ownClinic;
      default:
        return DoctorEmploymentType.inCenter;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'specialty': specialty,
    'degree': degree,
    'employmentType': employmentType.name,
    'clinicId': clinicId,
    'clinicName': clinicName,
    'isActive': isActive,
  };

  AdminDoctorModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? specialty,
    String? degree,
    DoctorEmploymentType? employmentType,
    String? clinicId,
    String? clinicName,
    bool? isActive,
  }) {
    return AdminDoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      degree: degree ?? this.degree,
      employmentType: employmentType ?? this.employmentType,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      isActive: isActive ?? this.isActive,
    );
  }
}
