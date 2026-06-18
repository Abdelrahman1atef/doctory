enum Gender {
  male(1, 'male'),
  female(2, 'female');

  final int value;
  final String translationKey;

  const Gender(this.value, this.translationKey);

  factory Gender.fromValue(int value) {
    return Gender.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Gender.male,
    );
  }
}
