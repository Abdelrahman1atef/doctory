enum AppointmentType {
  inPerson(1, 'in_person'),
  online(2, 'online'),
  followUp(3, 'follow_up');

  final int value;
  final String translationKey;

  const AppointmentType(this.value, this.translationKey);

  factory AppointmentType.fromValue(int value) {
    return AppointmentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AppointmentType.inPerson,
    );
  }
}
