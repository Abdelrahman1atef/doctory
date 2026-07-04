import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final int status;

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

  _StatusConfig _statusConfig(int status) {
    switch (AppointmentStatus.fromValue(status)) {
      case AppointmentStatus.confirmed:
        return _StatusConfig(AppColors.success, 'confirmed'.tr());
      case AppointmentStatus.pending:
        return _StatusConfig(AppColors.warning, 'pending_payment'.tr());
      case AppointmentStatus.reserved:
        return _StatusConfig(AppColors.warning, 'pending'.tr());
      case AppointmentStatus.completed:
        return _StatusConfig(AppColors.info, 'completed'.tr());
      case AppointmentStatus.cancelled:
        return _StatusConfig(AppColors.error, 'cancelled'.tr());
      case AppointmentStatus.noShow:
        return _StatusConfig(AppColors.grey500, 'no_show'.tr());
      case AppointmentStatus.accepted:
        return _StatusConfig(AppColors.success, 'accepted'.tr());
      case AppointmentStatus.rejected:
        return _StatusConfig(AppColors.error, 'rejected'.tr());
    }
  }
}

class _StatusConfig {
  final Color color;
  final String label;
  const _StatusConfig(this.color, this.label);
}
