class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? birthDate;
  final int? gender;
  final String? profilePictureUrl;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.birthDate,
    this.gender,
    this.profilePictureUrl,
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
    };
  }
}
