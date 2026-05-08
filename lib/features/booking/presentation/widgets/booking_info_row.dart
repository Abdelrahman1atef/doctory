import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// A reusable info row with icon + label + value for summary cards.
class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const BookingInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.s12Medium.withColor(AppColors.grey500),
            ),
            2.ph,
            Text(
              value,
              style: AppStyles.s14Bold.withColor(AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
