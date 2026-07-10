class AdminClinicModel {
  final String id;
  final String name;
  final String specialty;
  final String description;
  final String location;
  final String phone;
  final String managerName;
  final bool isActive;
  final int doctorCount;
  final int staffCount;
  final double avgRating;
  final List<String> specializations;

  const AdminClinicModel({
    required this.id,
    required this.name,
    this.specialty = '',
    this.description = '',
    this.location = '',
    this.phone = '',
    this.managerName = '',
    this.isActive = true,
    this.doctorCount = 0,
    this.staffCount = 0,
    this.avgRating = 0.0,
    this.specializations = const [],
  });

  factory AdminClinicModel.fromJson(Map<String, dynamic> json) {
    return AdminClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      managerName: json['managerName'] ?? '',
      isActive: json['isActive'] ?? true,
      doctorCount: json['doctorCount'] ?? 0,
      staffCount: json['staffCount'] ?? 0,
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'description': description,
    'location': location,
    'phone': phone,
    'managerName': managerName,
    'isActive': isActive,
    'doctorCount': doctorCount,
    'staffCount': staffCount,
    'avgRating': avgRating,
    'specializations': specializations,
  };

  AdminClinicModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? description,
    String? location,
    String? phone,
    String? managerName,
    bool? isActive,
    int? doctorCount,
    int? staffCount,
    double? avgRating,
    List<String>? specializations,
  }) {
    return AdminClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      managerName: managerName ?? this.managerName,
      isActive: isActive ?? this.isActive,
      doctorCount: doctorCount ?? this.doctorCount,
      staffCount: staffCount ?? this.staffCount,
      avgRating: avgRating ?? this.avgRating,
      specializations: specializations ?? this.specializations,
    );
  }
}
