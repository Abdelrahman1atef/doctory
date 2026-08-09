/// Rating row returned by the ratings endpoints (`RatingDto`).
class RatingDto {
  final String id;
  final int type;
  final String userId;
  final String? userName;
  final String? doctorId;
  final String? clinicId;
  final int value;
  final String? review;
  final String? createdAt;

  RatingDto({
    required this.id,
    required this.type,
    required this.userId,
    this.userName,
    this.doctorId,
    this.clinicId,
    required this.value,
    this.review,
    this.createdAt,
  });

  factory RatingDto.fromJson(Map<String, dynamic> json) {
    return RatingDto(
      id: json['id']?.toString() ?? '',
      type: (json['type'] as num?)?.toInt() ?? 0,
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString(),
      doctorId: json['doctorId']?.toString(),
      clinicId: json['clinicId']?.toString(),
      value: (json['value'] as num?)?.toInt() ?? 0,
      review: json['review']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}