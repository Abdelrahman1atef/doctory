enum MediaType {
  image(0),
  video(1),
  audio(2),
  file(3);

  final int value;
  const MediaType(this.value);

  factory MediaType.fromValue(dynamic value) {
    if (value == null) return MediaType.image;
    final intValue = int.tryParse(value.toString()) ?? 0;
    return MediaType.values.firstWhere(
      (e) => e.value == intValue,
      orElse: () => MediaType.image,
    );
  }
}
