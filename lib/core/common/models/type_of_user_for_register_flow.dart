enum TypeOfUserForRegisterFlow {
  user(1),
  freelanceDoctor(2),
  clinic(3);

  final int value;
  const TypeOfUserForRegisterFlow(this.value);

  static TypeOfUserForRegisterFlow? fromValue(int? value) {
    if (value == null) return null;
    for (final t in TypeOfUserForRegisterFlow.values) {
      if (t.value == value) return t;
    }
    return null;
  }
}
