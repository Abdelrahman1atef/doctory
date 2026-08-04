enum AppointmentStatus {
  pending(0, 'Pending'),
  confirmed(1, 'Confirmed'),
  cancelled(2, 'Cancelled'),
  completed(3, 'Completed'),
  reserved(4, 'Reserved'),
  noShow(5, 'NoShow'),
  accepted(6, 'Accepted'),
  rejected(7, 'Rejected');

  final int value;

  /// The exact string name the backend sends/receives (e.g. "Pending", "NoShow")
  final String apiName;

  const AppointmentStatus(this.value, this.apiName);

  /// Parse either an int (0–7) or a string ("Pending", "noshow", etc.)
  factory AppointmentStatus.from(dynamic raw) {
    if (raw == null) return AppointmentStatus.pending;

    // Integer value
    if (raw is int) {
      return AppointmentStatus.values.firstWhere(
        (e) => e.value == raw,
        orElse: () => AppointmentStatus.pending,
      );
    }

    // String name — case-insensitive, ignores underscores/spaces
    final normalized = raw.toString().toLowerCase().replaceAll('_', '').replaceAll(' ', '');
    return AppointmentStatus.values.firstWhere(
      (e) => e.apiName.toLowerCase() == normalized || e.name.toLowerCase() == normalized,
      orElse: () => AppointmentStatus.pending,
    );
  }

  /// Keep backward compat for existing callers
  factory AppointmentStatus.fromValue(int value) => AppointmentStatus.from(value);

  factory AppointmentStatus.fromString(String value) => AppointmentStatus.from(value);
}
