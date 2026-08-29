enum PaymentMethod {
  wallet('wallet', 'wallet_payment'),
  card('card', 'credit_card');

  final String serverValue;
  final String translationKey;

  const PaymentMethod(this.serverValue, this.translationKey);

  factory PaymentMethod.fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.serverValue == value,
      orElse: () => PaymentMethod.wallet,
    );
  }
}