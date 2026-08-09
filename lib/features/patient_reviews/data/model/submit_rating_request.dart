import 'rating_type.dart';

/// Request body for `POST /api/v1/ratings`.
///
/// Exactly one target must be set: `doctorId` for [RatingType.doctor],
/// `clinicId` for [RatingType.clinic] and [RatingType.placeCleanliness].
/// Never send both ids in the same call.
class SubmitRatingRequest {
  final RatingType type;
  final String? doctorId;
  final String? clinicId;
  final int value;
  final String? review;

  SubmitRatingRequest({
    required this.type,
    this.doctorId,
    this.clinicId,
    required this.value,
    this.review,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'value': value,
      'review': review,
    };
  }
}