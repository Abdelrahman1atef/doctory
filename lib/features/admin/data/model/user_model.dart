class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String registeredAt;
  final bool isActive;
  final int totalVisits;
  final double avgRating;

  const AdminUserModel({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.role = 'patient',
    this.registeredAt = '',
    this.isActive = true,
    this.totalVisits = 0,
    this.avgRating = 0.0,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'patient',
      registeredAt: json['registeredAt'] ?? '',
      isActive: json['isActive'] ?? true,
      totalVisits: json['totalVisits'] ?? 0,
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'registeredAt': registeredAt,
    'isActive': isActive,
    'totalVisits': totalVisits,
    'avgRating': avgRating,
  };
}
