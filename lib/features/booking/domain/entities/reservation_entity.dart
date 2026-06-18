class ReservationEntity {
  final String id;
  final DateTime expiresAt;
  final bool isActive;

  const ReservationEntity({
    required this.id,
    required this.expiresAt,
    required this.isActive,
  });

  Duration get timeRemaining => expiresAt.difference(DateTime.now());
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
