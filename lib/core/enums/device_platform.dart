enum DevicePlatform {
  web(0),
  android(1),
  iOS(2);

  final int value;
  const DevicePlatform(this.value);

  factory DevicePlatform.fromJson(int value) {
    return DevicePlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DevicePlatform.web,
    );
  }

  int toJson() => value;
}
