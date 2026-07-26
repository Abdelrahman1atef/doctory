class SpecialtyModel {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? iconUrl;
  final String? iconAsset;
  final bool isFamous;

  SpecialtyModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.iconUrl,
    this.iconAsset,
    this.isFamous = false,
  });

  /// The display name
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : name;

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['arName'] ?? '',
      nameAr: json['arName'] ?? json['nameAr'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      iconAsset: json['iconAsset'],
      isFamous: json['isFamous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arName': nameAr,
      'description': description,
      'iconUrl': iconUrl,
      'iconAsset': iconAsset,
      'isFamous': isFamous,
    };
  }
}
