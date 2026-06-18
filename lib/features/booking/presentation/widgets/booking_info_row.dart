import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class BookingInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? valueStyle;

  const BookingInfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s14Medium.withColor(AppColors.grey500),
          ),
        ),
        12.pw,
        Text(
          value,
          style: valueStyle ?? AppStyles.s14Bold.withColor(AppColors.textPrimary),
        ),
      ],
    );

    if (icon == null) return content;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.stitchPrimary),
        ),
        12.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppStyles.s12Medium.withColor(AppColors.grey500)),
              2.ph,
              Text(
                value,
                style: valueStyle ?? AppStyles.s14Bold.withColor(AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
