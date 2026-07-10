class AdminSpecializationModel {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String icon;
  final bool isActive;

  const AdminSpecializationModel({
    required this.id,
    required this.name,
    this.nameAr = '',
    this.description = '',
    this.icon = '',
    this.isActive = true,
  });

  factory AdminSpecializationModel.fromJson(Map<String, dynamic> json) {
    return AdminSpecializationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['arName'] ?? json['nameAr'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arName': nameAr,
    'description': description,
    'icon': icon,
    'isActive': isActive,
  };

  AdminSpecializationModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? icon,
    bool? isActive,
  }) {
    return AdminSpecializationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}
