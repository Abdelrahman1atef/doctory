import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/common/models/doctor_model.dart';

class ClinicDetailsResponseDto {
  final ClinicModel clinic;

  ClinicDetailsResponseDto({required this.clinic});

  static String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length < 2) return time;
    return '${parts[0].padLeft(2, '0')}:${parts[1]}';
  }

  factory ClinicDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    Map<String, String>? operatingHours;
    if (data['workingDays'] != null) {
      operatingHours = {};
      for (final day in data['workingDays'] as List) {
        final d = day as Map<String, dynamic>;
        final start = _formatTime(d['startTime'] as String?);
        final end = _formatTime(d['endTime'] as String?);
        operatingHours[d['dayOfWeek']?.toString() ?? ''] = '$start - $end';
      }
    }

    final workingDaysList = data['workingDays'] as List?;
    final isOpen = workingDaysList != null && workingDaysList.isNotEmpty;

    return ClinicDetailsResponseDto(
      clinic: ClinicModel(
        id: data['id']?.toString() ?? '',
        name: data['name'] ?? '',
        nameAr: data['nameAr'],
        description: data['description'] ?? '',
        descriptionAr: data['arDescription'] ?? data['descriptionAr'],
        imageUrl: data['imageUrl'],
        logo: data['logo'],
        rating: (data['rating'] ?? 0.0).toDouble(),
        cleanlinessRating: (data['cleanlinessRating'] ?? 0.0).toDouble(),
        behaviorRating: (data['behaviorRating'] ?? 0.0).toDouble(),
        receptionRating: (data['receptionRating'] ?? 0.0).toDouble(),
        address: data['address'],
        addressAr: data['addressAr'],
        phone: data['phone'],
        email: data['email'],
        website: data['website'],
        lat: (data['lat'] ?? 0.0).toDouble(),
        lng: (data['lng'] ?? 0.0).toDouble(),
        reviewsCount: data['reviewsCount'] ?? 0,
        photos: data['photos'] != null
            ? List<String>.from(data['photos'])
            : null,
        isRegistered: data['isRegistered'] ?? false,
        specializationName: data['specializationName'],
        specializationNameAr: data['specializationNameAr'],
        specialties: data['specialties'] != null
            ? List<String>.from(data['specialties'])
            : null,
        status: data['status'],
        isActive: data['isActive'] ?? true,
        doctors: data['doctors'] != null
            ? (data['doctors'] as List)
                .map((e) => DoctorModel.fromJson(e))
                .toList()
            : null,
        ownerName: data['ownerName'],
        ownerEmail: data['ownerEmail'],
        ownerPhone: data['ownerPhone'],
        subscriptionStatus: data['subscriptionStatus'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
        distance: (data['distance'] ?? 0.0).toDouble(),
        isOpen: isOpen,
        operatingHours: operatingHours,
      ),
    );
  }
}
