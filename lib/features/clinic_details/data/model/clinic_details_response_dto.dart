import 'package:doctory/core/common/models/clinic_model.dart';

class ClinicDetailsResponseDto {
  final ClinicModel clinic;

  ClinicDetailsResponseDto({required this.clinic});

  static String _formatTo12Hour(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:$minute';
  }

  factory ClinicDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    Map<String, String>? operatingHours;
    if (data['workingDays'] != null) {
      operatingHours = {};
      for (final day in data['workingDays'] as List) {
        final d = day as Map<String, dynamic>;
        final start = _formatTo12Hour(d['startTime'] as String?);
        final end = _formatTo12Hour(d['endTime'] as String?);
        operatingHours[d['dayOfWeek'] as String] = '$start - $end';
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
        address: data['address'],
        addressAr: data['addressAr'],
        phone: data['phone'],
        email: data['email'],
        website: data['website'],
        lat: (data['lat'] ?? 0.0).toDouble(),
        lng: (data['lng'] ?? 0.0).toDouble(),
        isRegistered: data['isRegistered'] ?? false,
        specializationName: data['specializationName'],
        specializationNameAr: data['specializationNameAr'],
        status: data['status'],
        isActive: data['isActive'] ?? true,
        ownerName: data['ownerName'],
        ownerEmail: data['ownerEmail'],
        ownerPhone: data['ownerPhone'],
        subscriptionStatus: data['subscriptionStatus'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
        isOpen: isOpen,
        operatingHours: operatingHours,
      ),
    );
  }
}
