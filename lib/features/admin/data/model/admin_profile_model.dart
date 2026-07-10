class AdminProfileModel {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String permissionLevel;
  final String registeredAt;
  final String lastLogin;
  final String initials;

  const AdminProfileModel({
    this.name = '',
    this.role = '',
    this.email = '',
    this.phone = '',
    this.permissionLevel = '',
    this.registeredAt = '',
    this.lastLogin = '',
    this.initials = '',
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      permissionLevel: json['permissionLevel'] ?? '',
      registeredAt: json['registeredAt'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      initials: json['initials'] ?? '',
    );
  }
}
