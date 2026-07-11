enum TypeOfUserForRegisterFlow {
  user(0),
  freelanceDoctor(1),
  clinic(2);

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
