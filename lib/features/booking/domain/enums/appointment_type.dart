enum AppointmentType {
  inPerson(0, 'in_person'),
  followUp(1, 'follow_up');
  // online(2, 'online'),

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
