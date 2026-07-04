class SignupRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String? birthDate;
  final int? gender;
  final String? role;
  final String? certificateImagePath;
  final String? syndicateIdImagePath;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    this.birthDate,
    this.gender,
    this.role,
    this.certificateImagePath,
    this.syndicateIdImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber,
      if (birthDate != null) 'birthDate': birthDate,
      if (gender != null) 'gender': gender,
      if (role != null) 'role': role,
    };
  }
}
