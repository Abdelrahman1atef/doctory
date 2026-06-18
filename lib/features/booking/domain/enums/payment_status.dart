enum PaymentStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  refunded('refunded'),
  cancelled('cancelled'),
  expired('expired');

  final String value;

  const PaymentStatus(this.value);

  factory PaymentStatus.fromValue(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }

  bool get isFinal => this == completed || this == failed || this == refunded || this == cancelled || this == expired;
}
