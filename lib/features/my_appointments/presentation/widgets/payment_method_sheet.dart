import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/domain/enums/payment_method.dart';
import 'package:doctory/features/my_appointments/domain/payment_selection.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/payment_option_widget.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/wallet_phone_field_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Asks which method to pay an accepted appointment with and, for wallet
/// payments, the e-wallet phone number to charge.
///
/// Returns the [PaymentSelection], or null when dismissed.
Future<PaymentSelection?> showPaymentMethodSheet(
  BuildContext context, {
  String? initialWalletPhone,
}) {
  return showModalBottomSheet<PaymentSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.stitchSurfaceLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        _PaymentMethodSheet(initialWalletPhone: initialWalletPhone),
  );
}

class _PaymentMethodSheet extends StatefulWidget {
  final String? initialWalletPhone;

  const _PaymentMethodSheet({this.initialWalletPhone});

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _phoneController =
      TextEditingController(text: widget.initialWalletPhone);
  PaymentMethod _selected = PaymentMethod.wallet;

  bool get _isWallet => _selected == PaymentMethod.wallet;

  IconData _iconFor(PaymentMethod method) => switch (method) {
        PaymentMethod.wallet => Icons.account_balance_wallet_rounded,
        PaymentMethod.card => Icons.credit_card_rounded,
      };

  void _submit() {
    if (_isWallet && !_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(PaymentSelection(
      method: _selected,
      walletPhoneNumber: _isWallet ? _phoneController.text.trim() : null,
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose_payment_method'.tr(),
                style: AppStyles.s18Bold
                    .withColor(AppColors.stitchPrimaryContainer),
              ),
              16.ph,
              Row(
                children: [
                  for (final method in PaymentMethod.values) ...[
                    Expanded(
                      child: PaymentOptionWidget(
                        icon: _iconFor(method),
                        title: method.translationKey.tr(),
                        isSelected: _selected == method,
                        onTap: () => setState(() => _selected = method),
                      ),
                    ),
                    if (method != PaymentMethod.values.last) 12.pw,
                  ],
                ],
              ),
              if (_isWallet) ...[
                20.ph,
                WalletPhoneFieldWidget(controller: _phoneController),
              ],
              20.ph,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stitchPrimaryContainer,
                    foregroundColor: AppColors.stitchSurfaceLowest,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: AppStyles.s16Bold,
                  ),
                  child: Text('pay_now'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
