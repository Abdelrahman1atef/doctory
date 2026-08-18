import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/domain/enums/payment_method.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PaymentOption(
            icon: Icons.account_balance_wallet_rounded,
            title: PaymentMethod.wallet.translationKey.tr(),
            isSelected: selectedMethod == PaymentMethod.wallet,
            onTap: () => onSelected(PaymentMethod.wallet),
          ),
        ),
        12.pw,
        Expanded(
          child: _PaymentOption(
            icon: Icons.credit_card_rounded,
            title: PaymentMethod.card.translationKey.tr(),
            isSelected: selectedMethod == PaymentMethod.card,
            onTap: () => onSelected(PaymentMethod.card),
          ),
        ),
      ],
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
              color: isSelected
                  ? AppColors.stitchPrimary
                  : AppColors.textSecondary,
            ),
            8.ph,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.s14SemiBold.withColor(
                isSelected
                    ? AppColors.stitchPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}