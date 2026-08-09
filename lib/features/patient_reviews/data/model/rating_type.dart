/// Rating types accepted by the backend `POST /api/v1/ratings` endpoint.
/// Must be sent as integers (1-3) — the backend has no string enum converter.
enum RatingType {
  doctor(1),
  clinic(2),
  placeCleanliness(3);

  const RatingType(this.value);

  final int value;
}

/// The entity a reviews screen is attached to (decides which sections shown).
enum RatingEntityType {
  doctor,
  clinic,
}