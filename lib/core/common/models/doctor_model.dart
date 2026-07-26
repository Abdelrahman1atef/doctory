import 'doctor_availability_dto.dart';
import 'doctor_rating_summary_dto.dart';
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
  final double? cleanlinessRating;
  final double? behaviorRating;
  final double? receptionRating;
  final int reviewsCount;
  final int? experience;
  final int? patientsCount;
  final String? bio;
  final String? bioAr;
  final List<String>? qualifications;
  final Map<String, List<TimeSlotModel>>? availableSlots;
  final bool isFreelance;
  final String? clinicId;
  final String? clinicName;
  final String? specializationId;
  final List<DoctorRatingSummaryDto>? recentRatings;
  final List<DoctorAvailabilityDto>? availabilities;

  DoctorModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.specialty,
    this.specialtyAr,
    this.nextAppointment,
    this.imageUrl,
    this.rating = 0.0,
    this.cleanlinessRating,
    this.behaviorRating,
    this.receptionRating,
    this.reviewsCount = 0,
    this.experience,
    this.patientsCount,
    this.bio,
    this.bioAr,
    this.qualifications,
    this.availableSlots,
    this.isFreelance = false,
    this.clinicId,
    this.clinicName,
    this.specializationId,
    this.recentRatings,
    this.availabilities,
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
      name: json['name'] ?? json['fullName'] ?? '',
      nameAr: json['nameAr'],
      specialty: json['specialty'] ?? json['specializationEnName'] ?? json['specializationName'] ?? '',
      specialtyAr: json['specialtyAr'] ?? json['specializationArName'],
      nextAppointment: json['nextAppointment'],
      imageUrl: json['imageUrl'] ?? json['image'] ?? json['profilePictureUrl'],
      rating: (json['rating'] ?? json['averageRating'] ?? 0.0).toDouble(),
      cleanlinessRating: (json['cleanlinessRating'] ?? 0.0).toDouble(),
      behaviorRating: (json['behaviorRating'] ?? 0.0).toDouble(),
      receptionRating: (json['receptionRating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? json['totalRatings'] ?? 0,
      experience: json['experience'] ?? json['yearsOfExperience'],
      patientsCount: json['patientsCount'],
      bio: json['bio'],
      bioAr: json['bioAr'],
      qualifications: json['qualifications'] != null
          ? List<String>.from(json['qualifications'])
          : null,
      availableSlots: parsedSlots,
      isFreelance: json['isFreelance'] ?? false,
      clinicId: json['clinicId']?.toString(),
      clinicName: json['clinicName'],
      specializationId: json['specializationId']?.toString(),
      recentRatings: json['recentRatings'] != null
          ? (json['recentRatings'] as List)
              .map((e) => DoctorRatingSummaryDto.fromJson(e))
              .toList()
          : null,
      availabilities: json['availabilities'] != null
          ? (json['availabilities'] as List)
              .map((e) => DoctorAvailabilityDto.fromJson(e))
              .toList()
          : null,
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
      'cleanlinessRating': cleanlinessRating,
      'behaviorRating': behaviorRating,
      'receptionRating': receptionRating,
      'reviewsCount': reviewsCount,
      'experience': experience,
      'patientsCount': patientsCount,
      'bio': bio,
      'bioAr': bioAr,
      'qualifications': qualifications,
      'availableSlots': encodedSlots,
      'isFreelance': isFreelance,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'specializationId': specializationId,
      'recentRatings': recentRatings?.map((e) => e.toJson()).toList(),
      'availabilities': availabilities?.map((e) => e.toJson()).toList(),
    };
  }
}
