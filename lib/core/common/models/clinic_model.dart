import 'doctor_model.dart';

class ClinicModel {
  final String id;
  final String name;
  final String? nameAr;
  final String description;
  final String? descriptionAr;
  final String? imageUrl;
  final double rating;
  final double? cleanlinessRating;
  final double? behaviorRating;
  final double? receptionRating;

  // Extended fields for details
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? website;
  final String? logo;
  final double? lat;
  final double? lng;
  final int reviewsCount;
  final List<String>? photos;
  final Map<String, String>?
      operatingHours; // e.g., {'Monday': '09:00 - 17:00'}
  final bool isOpen;
  final int? status;
  final bool isActive;
  final List<DoctorModel>? doctors;
  final List<String>? specialties;
  final bool isRegistered;
  final String? specializationName;
  final String? specializationNameAr;
  final String? ownerName;
  final String? ownerEmail;
  final String? ownerPhone;
  final String? subscriptionStatus;
  final String? createdAt;
  final String? updatedAt;
  final double distance;

  ClinicModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.description,
    this.descriptionAr,
    this.imageUrl,
    this.rating = 0.0,
    this.cleanlinessRating,
    this.behaviorRating,
    this.receptionRating,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
    this.website,
    this.logo,
    this.lat,
    this.lng,
    this.reviewsCount = 0,
    this.photos,
    this.operatingHours,
    this.isOpen = true,
    this.status,
    this.isActive = true,
    this.doctors,
    this.specialties,
    this.isRegistered = false,
    this.specializationName,
    this.specializationNameAr,
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    this.subscriptionStatus,
    this.createdAt,
    this.updatedAt,
    this.distance = 0.0,
  });

  /// Mock data for UI testing
  static List<ClinicModel> get mockClinics => [
        ClinicModel(
          id: '1',
          name: 'عيادة النور (Registered)',
          description: 'عيادة مسجلة في نظامنا بكل البيانات',
          isRegistered: true,
          rating: 4.8,
          lat: 31.0409,
          lng: 31.3785,
          address: 'المنصورة، شارع المشاية',
          isOpen: true,
        ),
        ClinicModel(
          id: '2',
          name: 'مستشفى الشفاء (Google Maps)',
          description: 'بيانات مسترجعة من بحث جوجل - بدون تقييم',
          isRegistered: false,
          rating: 0.0,
          lat: 31.0348,
          lng: 31.3575,
          address: 'المنصورة، حي الجامعة',
          isOpen: false,
        ),
      ];

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

  /// Distance formatted (input is in meters from API)
  String get distanceFormatted {
    final meters = distance;
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? json['arDescription'],
      imageUrl: json['imageUrl'],
      rating: double.parse((json['rating'] ?? 0.0).toStringAsFixed(2)),
      cleanlinessRating: (json['cleanlinessRating'] ?? 0.0).toDouble(),
      behaviorRating: (json['behaviorRating'] ?? 0.0).toDouble(),
      receptionRating: (json['receptionRating'] ?? 0.0).toDouble(),
      address: json['address'],
      addressAr: json['addressAr'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      logo: json['logo'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      operatingHours: json['operatingHours'] != null
          ? Map<String, String>.from(json['operatingHours'])
          : null,
      isOpen: json['isOpen'] ?? true,
      status: json['status'],
      isActive: json['isActive'] ?? true,
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
      specializationNameAr: json['specializationNameAr'],
      ownerName: json['ownerName'],
      ownerEmail: json['ownerEmail'],
      ownerPhone: json['ownerPhone'],
      subscriptionStatus: json['subscriptionStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
      'cleanlinessRating': cleanlinessRating,
      'behaviorRating': behaviorRating,
      'receptionRating': receptionRating,
      'address': address,
      'addressAr': addressAr,
      'phone': phone,
      'email': email,
      'website': website,
      'logo': logo,
      'lat': lat,
      'lng': lng,
      'reviewsCount': reviewsCount,
      'photos': photos,
      'operatingHours': operatingHours,
      'isOpen': isOpen,
      'status': status,
      'isActive': isActive,
      'doctors': doctors?.map((e) => e.toJson()).toList(),
      'specialties': specialties,
      'isRegistered': isRegistered,
      'specializationName': specializationName,
      'specializationNameAr': specializationNameAr,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'subscriptionStatus': subscriptionStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'distance': distance,
    };
  }
}
