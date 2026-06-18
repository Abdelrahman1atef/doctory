import '../enums/gender.dart';

class PatientEntity {
  final String fullName;
  final String phoneNumber;
  final String age;
  final Gender gender;
  final String complaint;
  final String? chronicDiseases;

  const PatientEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.complaint,
    this.chronicDiseases,
  });

  PatientEntity copyWith({
    String? fullName,
    String? phoneNumber,
    String? age,
    Gender? gender,
    String? complaint,
    String? chronicDiseases,
  }) {
    return PatientEntity(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      complaint: complaint ?? this.complaint,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
    );
  }
}
