import 'package:doctory/core/common/models/role.dart';

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
  final UserRole? userRole;
  final List<Permission>? permissions;
  final DoctorEmploymentType? doctorType;
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
    this.userRole,
    this.permissions,
    this.doctorType,
    this.certificateImage,
    this.syndicateIdImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRole = (json['role'] ?? json['roles'])?.toString();
    final rawPermissions = json['permissions'] as List<dynamic>? ?? [];
    final permissions = rawPermissions
        .map((e) => Permission.fromJson(e?.toString()))
        .whereType<Permission>()
        .toList();

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
      role: rawRole,
      userRole: UserRole.fromJson(rawRole),
      permissions: permissions.isNotEmpty ? permissions : null,
      doctorType: DoctorEmploymentType.fromJson(json['doctorType']?.toString()),
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
      'role': userRole?.toJson() ?? role,
      'doctorType': doctorType?.name,
      'permissions': permissions?.map((p) => p.name).toList(),
      'certificate_image': certificateImage,
      'syndicate_id_image': syndicateIdImage,
    };
  }
}
