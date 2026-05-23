enum LastMessageContentType {
  text(0),
  media(1),
  textAndMedia(2);

  final int value;
  const LastMessageContentType(this.value);

  factory LastMessageContentType.fromValue(dynamic value) {
    if (value == null) return LastMessageContentType.text;
    final intValue = int.tryParse(value.toString()) ?? 0;
    return LastMessageContentType.values.firstWhere(
      (e) => e.value == intValue,
      orElse: () => LastMessageContentType.text,
    );
  }
}
