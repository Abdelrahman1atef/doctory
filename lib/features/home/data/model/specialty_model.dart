class SpecialtyModel {
  final String id;
  final String name;
  final String iconAsset;

  SpecialtyModel({
    required this.id,
    required this.name,
    required this.iconAsset,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      iconAsset: json['iconAsset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'iconAsset': iconAsset};
  }
}
