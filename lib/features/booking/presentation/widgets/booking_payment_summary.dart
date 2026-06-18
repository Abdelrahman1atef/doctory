import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_info_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingPaymentSummary extends StatelessWidget {
  final double amount;
  final String currency;

  const BookingPaymentSummary({
    super.key,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          BookingInfoRow(
            label: 'consultation_fee'.tr(),
            value: '${amount.toStringAsFixed(0)} $currency',
          ),
          const Divider(height: 24),
          BookingInfoRow(
            label: 'total'.tr(),
            value: '${amount.toStringAsFixed(0)} $currency',
            valueStyle: AppStyles.s18Bold.withColor(AppColors.stitchPrimary),
          ),
        ],
      ),
    );
  }
}
