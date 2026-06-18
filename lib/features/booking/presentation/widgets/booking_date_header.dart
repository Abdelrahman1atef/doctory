import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class BookingDateHeader extends StatelessWidget {
  final String formattedDate;

  const BookingDateHeader({super.key, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.stitchPrimary),
          8.pw,
          Text(
            formattedDate,
            style: AppStyles.s14Bold.withColor(AppColors.stitchPrimary),
          ),
        ],
      ),
    );
  }
}
