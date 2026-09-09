import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/domain/enums/payment_method.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Read-only summary of how the booking will be paid for.
///
/// Nothing here is tappable: the patient does not pay while booking. The clinic
/// has to accept the request first, and only then can the patient pay from the
/// My Appointments screen.
class PaymentMethodInfo extends StatelessWidget {
  const PaymentMethodInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 20,
                color: AppColors.stitchPrimary,
              ),
              8.pw,
              Expanded(
                child: Text(
                  'payment_after_confirmation_title'.tr(),
                  style: AppStyles.s14SemiBold
                      .withColor(AppColors.stitchPrimary),
                ),
              ),
            ],
          ),
          8.ph,
          Text(
            'payment_after_confirmation_note'.tr(),
            style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
          ),
          16.ph,
          Text(
            'available_payment_methods'.tr(),
            style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
          ),
          8.ph,
          Row(
            children: [
              for (final method in PaymentMethod.values) ...[
                _MethodChip(method: method),
                if (method != PaymentMethod.values.last) 8.pw,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final PaymentMethod method;

  const _MethodChip({required this.method});

  IconData get _icon => switch (method) {
        PaymentMethod.wallet => Icons.account_balance_wallet_rounded,
        PaymentMethod.card => Icons.credit_card_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 18, color: AppColors.textSecondary),
          6.pw,
          Text(
            method.translationKey.tr(),
            style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
