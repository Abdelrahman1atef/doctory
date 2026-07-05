enum NotificationType {
  appointmentReminder(0),
  newMessage(1),
  paymentConfirmation(2),
  appointmentConfirmation(3),
  appointmentCancellation(4),
  systemAnnouncement(5);

  final int value;
  const NotificationType(this.value);

  factory NotificationType.fromJson(dynamic value) {
    if (value is int) {
      return NotificationType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => NotificationType.systemAnnouncement,
      );
    }
    if (value is String) {
      return NotificationType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => NotificationType.systemAnnouncement,
      );
    }
    return NotificationType.systemAnnouncement;
  }

  dynamic toJson() => name;
}
