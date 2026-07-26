import 'package:doctory/core/common/models/doctor_model.dart';

class DoctorDetailsResponseDto {
  final DoctorModel doctor;

  DoctorDetailsResponseDto({required this.doctor});

  factory DoctorDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return DoctorDetailsResponseDto(
      doctor: DoctorModel.fromJson(data),
    );
  }
}
