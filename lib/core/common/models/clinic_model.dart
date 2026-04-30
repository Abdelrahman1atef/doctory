import 'doctor_model.dart';

class ClinicModel {
  final String id;
  final String name;
  final String? nameAr;
  final String description;
  final String? descriptionAr;
  final String? imageUrl;
  final double rating;

  // Extended fields for details
  final String? address;
  final String? addressAr;
  final String? phone;
  final double? lat;
  final double? lng;
  final int reviewsCount;
  final List<String>? photos;
  final Map<String, String>? operatingHours; // e.g., {'Monday': '09:00 - 17:00'}
  final bool isOpen;
  final List<DoctorModel>? doctors;
  final List<String>? specialties;
  final bool isRegistered;
  final String? specializationName;
  final double distance;

  ClinicModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.description,
    this.descriptionAr,
    this.imageUrl,
    this.rating = 0.0,
    this.address,
    this.addressAr,
    this.phone,
    this.lat,
    this.lng,
    this.reviewsCount = 0,
    this.photos,
    this.operatingHours,
    this.isOpen = true,
    this.doctors,
    this.specialties,
    this.isRegistered = false,
    this.specializationName,
    this.distance = 0.0,
  });

  /// The display name
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : name;

  /// The display description
  String get displayDescription =>
      (descriptionAr != null && descriptionAr!.isNotEmpty)
          ? descriptionAr!
          : description;

  /// The display address
  String get displayAddress => (addressAr != null && addressAr!.isNotEmpty)
      ? addressAr!
      : (address ?? '');

  /// Distance formatted in km
  String get distanceFormatted {
    final km = distance; // Already in km from API
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      address: json['address'],
      addressAr: json['addressAr'],
      phone: json['phone'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      operatingHours: json['operatingHours'] != null
          ? Map<String, String>.from(json['operatingHours'])
          : null,
      isOpen: json['isOpen'] ?? true,
      doctors: json['doctors'] != null
          ? (json['doctors'] as List)
              .map((e) => DoctorModel.fromJson(e))
              .toList()
          : null,
      specialties: json['specialties'] != null
          ? List<String>.from(json['specialties'])
          : null,
      isRegistered: json['isRegistered'] ?? false,
      specializationName: json['specializationName'],
      distance: (json['distance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'imageUrl': imageUrl,
      'rating': rating,
      'address': address,
      'addressAr': addressAr,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'reviewsCount': reviewsCount,
      'photos': photos,
      'operatingHours': operatingHours,
      'isOpen': isOpen,
      'doctors': doctors?.map((e) => e.toJson()).toList(),
      'specialties': specialties,
      'isRegistered': isRegistered,
      'specializationName': specializationName,
      'distance': distance,
    };
  }
}
