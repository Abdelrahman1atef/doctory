class UpdateProfileRequest {
  final String? fullName;
  final String? phoneNumber;
  final String? birthDate;
  final int? gender;
  final String? profileImageUrl;

  UpdateProfileRequest({
    this.fullName,
    this.phoneNumber,
    this.birthDate,
    this.gender,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (birthDate != null) 'birthDate': birthDate,
      if (gender != null) 'gender': gender,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    };
  }
}
