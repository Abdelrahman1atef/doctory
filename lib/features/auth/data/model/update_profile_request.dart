class UpdateProfileRequest {
  final String fullName;
  final String phoneNumber;
  final String birthDate;
  final int gender;

  UpdateProfileRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
    };
  }
}
