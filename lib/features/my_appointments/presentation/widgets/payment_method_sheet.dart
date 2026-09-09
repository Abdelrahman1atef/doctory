import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/domain/enums/payment_method.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Asks which method to pay an accepted appointment with.
///
/// Returns the chosen [PaymentMethod], or null when dismissed.
Future<PaymentMethod?> showPaymentMethodSheet(BuildContext context) {
  return showModalBottomSheet<PaymentMethod>(
    context: context,
    backgroundColor: AppColors.stitchSurfaceLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _PaymentMethodSheet(),
  );
}

class _PaymentMethodSheet extends StatefulWidget {
  const _PaymentMethodSheet();

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  PaymentMethod _selected = PaymentMethod.wallet;

  IconData _iconFor(PaymentMethod method) => switch (method) {
        PaymentMethod.wallet => Icons.account_balance_wallet_rounded,
        PaymentMethod.card => Icons.credit_card_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                    child: _PaymentOption(
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
            20.ph,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selected),
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
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryFixed
              : AppColors.stitchSurfaceLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.grey200,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected ? AppColors.stitchPrimary : AppColors.textSecondary,
            ),
            8.ph,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.s14SemiBold.withColor(
                isSelected ? AppColors.stitchPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
