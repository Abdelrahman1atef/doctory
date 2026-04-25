class ClinicModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double rating;

  ClinicModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.rating = 0.0,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}
