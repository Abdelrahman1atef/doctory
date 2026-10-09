import 'package:doctory/features/booking/domain/enums/payment_method.dart';

/// What the patient picked in the payment sheet.
///
/// [walletPhoneNumber] is set only for [PaymentMethod.wallet], where the
/// gateway charges the e-wallet registered to that number.
class PaymentSelection {
  final PaymentMethod method;
  final String? walletPhoneNumber;

  const PaymentSelection({
    required this.method,
    this.walletPhoneNumber,
  });
}
