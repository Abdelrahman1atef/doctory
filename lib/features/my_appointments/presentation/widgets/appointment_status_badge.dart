import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final String status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        config.label,
        style: AppStyles.s12Medium.copyWith(color: config.color),
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    switch (status) {
      case 'confirmed':
        return _StatusConfig(AppColors.success, 'confirmed'.tr());
      case 'pending':
      case 'reserved':
        return _StatusConfig(AppColors.warning, 'pending'.tr());
      case 'completed':
        return _StatusConfig(AppColors.info, 'completed'.tr());
      case 'cancelled':
        return _StatusConfig(AppColors.error, 'cancelled'.tr());
      default:
        return _StatusConfig(AppColors.grey500, status);
    }
  }
}

class _StatusConfig {
  final Color color;
  final String label;
  const _StatusConfig(this.color, this.label);
}
