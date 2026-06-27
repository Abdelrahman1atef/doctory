import 'package:doctory/core/common/models/clinic_model.dart';

class ClinicDetailsResponseDto {
  final ClinicModel clinic;

  ClinicDetailsResponseDto({required this.clinic});

  factory ClinicDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    Map<String, String>? operatingHours;
    if (data['workingDays'] != null) {
      operatingHours = {};
      for (final day in data['workingDays'] as List) {
        final d = day as Map<String, dynamic>;
        operatingHours[d['dayOfWeek'] as String] =
            '${d['startTime']} - ${d['endTime']}';
      }
    }

    return ClinicDetailsResponseDto(
      clinic: ClinicModel(
        id: data['id']?.toString() ?? '',
        name: data['name'] ?? '',
        nameAr: data['nameAr'],
        description: data['description'] ?? '',
        descriptionAr: data['arDescription'] ?? data['descriptionAr'],
        imageUrl: data['imageUrl'],
        rating: (data['rating'] ?? 0.0).toDouble(),
        address: data['address'],
        addressAr: data['addressAr'],
        phone: data['phone'],
        lat: (data['lat'] ?? 0.0).toDouble(),
        lng: (data['lng'] ?? 0.0).toDouble(),
        isRegistered: data['isRegistered'] ?? false,
        specializationName: data['specializationName'],
        isOpen: true,
        operatingHours: operatingHours,
      ),
    );
  }
}
