import 'time_slot_model.dart';

class DoctorModel {
  final String id;
  final String name;
  final String? nameAr;
  final String specialty;
  final String? specialtyAr;
  final String? nextAppointment;
  final String? imageUrl;
  final double rating;
  final int reviewsCount;
  final int? experience; // in years
  final int? patientsCount;
  final String? bio;
  final String? bioAr;
  final List<String>? qualifications;
  final Map<String, List<TimeSlotModel>>?
  availableSlots; // Map of ISO Date String to slots

  DoctorModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.specialty,
    this.specialtyAr,
    this.nextAppointment,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.experience,
    this.patientsCount,
    this.bio,
    this.bioAr,
    this.qualifications,
    this.availableSlots,
  });

  /// The display name: prefer Arabic name if available, fallback to name.
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : name;

  /// The display specialty: prefer Arabic if available, fallback to specialty.
  String get displaySpecialty =>
      (specialtyAr != null && specialtyAr!.isNotEmpty)
      ? specialtyAr!
      : specialty;

  /// The display bio
  String get displayBio =>
      (bioAr != null && bioAr!.isNotEmpty) ? bioAr! : (bio ?? '');

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<TimeSlotModel>>? parsedSlots;
    if (json['availableSlots'] != null) {
      parsedSlots = {};
      (json['availableSlots'] as Map<String, dynamic>).forEach((key, value) {
        parsedSlots![key] = (value as List)
            .map((slot) => TimeSlotModel.fromJson(slot))
            .toList();
      });
    }

    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      specialty: json['specialty'] ?? '',
      specialtyAr: json['specialtyAr'],
      nextAppointment: json['nextAppointment'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      experience: json['experience'],
      patientsCount: json['patientsCount'],
      bio: json['bio'],
      bioAr: json['bioAr'],
      qualifications: json['qualifications'] != null
          ? List<String>.from(json['qualifications'])
          : null,
      availableSlots: parsedSlots,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? encodedSlots;
    if (availableSlots != null) {
      encodedSlots = {};
      availableSlots!.forEach((key, value) {
        encodedSlots![key] = value.map((slot) => slot.toJson()).toList();
      });
    }

    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'specialty': specialty,
      'specialtyAr': specialtyAr,
      'nextAppointment': nextAppointment,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'experience': experience,
      'patientsCount': patientsCount,
      'bio': bio,
      'bioAr': bioAr,
      'qualifications': qualifications,
      'availableSlots': encodedSlots,
    };
  }
}
