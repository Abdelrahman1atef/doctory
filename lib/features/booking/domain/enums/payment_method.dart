enum PaymentMethod {
  wallet(0, 'wallet_payment'),
  card(1, 'credit_card');

  final int value;
  final String translationKey;

  const PaymentMethod(this.value, this.translationKey);

  factory PaymentMethod.fromValue(int value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentMethod.wallet,
    );
  }
}