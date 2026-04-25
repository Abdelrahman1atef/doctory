class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? nextAppointment;
  final String? imageUrl;
  final double rating;
  final int reviewsCount;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.nextAppointment,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      nextAppointment: json['nextAppointment'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'nextAppointment': nextAppointment,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }
}
