enum MessageStatus {
  pending(1),
  sent(2),
  delivered(3),
  read(4),
  failed(5);

  final int value;
  const MessageStatus(this.value);

  factory MessageStatus.fromValue(dynamic value) {
    final intValue = int.tryParse(value.toString()) ?? 0;
    return MessageStatus.values.firstWhere(
      (e) => e.value == intValue,
      orElse: () => MessageStatus.sent,
    );
  }
}
