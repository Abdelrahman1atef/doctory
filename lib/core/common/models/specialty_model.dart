class SpecialtyModel {
  final String id;
  final String name;
  final String? nameAr;
  final String iconAsset;

  SpecialtyModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.iconAsset,
  });

  /// The display name
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : name;

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      iconAsset: json['iconAsset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nameAr': nameAr, 'iconAsset': iconAsset};
  }
}
