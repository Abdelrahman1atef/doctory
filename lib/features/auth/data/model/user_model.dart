class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? birthDate;
  final int? gender;
  final String? profilePictureUrl;
  final int? language;
  final String? role;
  final String? certificateImage;
  final String? syndicateIdImage;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.birthDate,
    this.gender,
    this.profilePictureUrl,
    this.language,
    this.role,
    this.certificateImage,
    this.syndicateIdImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],
      gender: json['gender'] is int
          ? json['gender']
          : int.tryParse(json['gender']?.toString() ?? ''),
      profilePictureUrl: json['profilePictureUrl'] ?? json['profileImage'],
      language: json['language'] is int
          ? json['language']
          : int.tryParse(json['language']?.toString() ?? ''),
      role: json['role']?.toString(),
      certificateImage: json['certificate_image']?.toString(),
      syndicateIdImage: json['syndicate_id_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'language': language,
      'role': role,
      'certificate_image': certificateImage,
      'syndicate_id_image': syndicateIdImage,
    };
  }
}
