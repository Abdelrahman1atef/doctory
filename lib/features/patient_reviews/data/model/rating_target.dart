import 'rating_type.dart';

/// Identifies the entity a patient rates/reviews on the reviews screen.
class RatingTarget {
  final RatingEntityType entityType;

  /// Entity id — the doctor or clinic entity id used in API paths.
  final String entityId;

  const RatingTarget._({required this.entityType, required this.entityId});

  const RatingTarget.doctor(String doctorId)
    : this._(entityType: RatingEntityType.doctor, entityId: doctorId);

  const RatingTarget.clinic(String clinicId)
    : this._(entityType: RatingEntityType.clinic, entityId: clinicId);

  String? get doctorId =>
      entityType == RatingEntityType.doctor ? entityId : null;

  String? get clinicId =>
      entityType == RatingEntityType.clinic ? entityId : null;
}