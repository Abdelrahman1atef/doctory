enum AppointmentStatus {
  pending(0),
  confirmed(1),
  cancelled(2),
  completed(3),
  reserved(4),
  noShow(5),
  accepted(6),
  rejected(7);

  final int value;
  const AppointmentStatus(this.value);

  factory AppointmentStatus.fromValue(int value) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AppointmentStatus.pending,
    );
  }
}
