class DoctorRatingSummaryDto {
  final String id;
  final String reviewerName;
  final String? reviewerProfilePictureUrl;
  final int value;
  final String? review;
  final DateTime createdAt;

  DoctorRatingSummaryDto({
    required this.id,
    required this.reviewerName,
    this.reviewerProfilePictureUrl,
    required this.value,
    this.review,
    required this.createdAt,
  });

  factory DoctorRatingSummaryDto.fromJson(Map<String, dynamic> json) {
    return DoctorRatingSummaryDto(
      id: json['id']?.toString() ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerProfilePictureUrl: json['reviewerProfilePictureUrl'],
      value: json['value'] as int? ?? 0,
      review: json['review'],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerName': reviewerName,
      'reviewerProfilePictureUrl': reviewerProfilePictureUrl,
      'value': value,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
