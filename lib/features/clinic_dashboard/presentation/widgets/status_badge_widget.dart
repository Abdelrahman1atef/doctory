import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class StatusBadgeWidget extends StatelessWidget {
  final Color color;
  final String text;

  const StatusBadgeWidget({
    super.key,
    required this.color,
    required this.text,
  });

  factory StatusBadgeWidget.pending() {
    return StatusBadgeWidget(
      color: AppColors.warning,
      text: 'Pending',
    );
  }

  factory StatusBadgeWidget.accepted() {
    return StatusBadgeWidget(
      color: AppColors.success,
      text: 'Accepted',
    );
  }

  factory StatusBadgeWidget.rejected() {
    return StatusBadgeWidget(
      color: AppColors.error,
      text: 'Rejected',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppStyles.s12Medium.withColor(color),
      ),
    );
  }
}
