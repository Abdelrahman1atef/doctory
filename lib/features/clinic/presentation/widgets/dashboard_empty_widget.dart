import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DashboardEmptyWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const DashboardEmptyWidget({
    super.key,
    required this.icon,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.grey300),
          const SizedBox(height: 12),
          Text(
            message.isNotEmpty
                ? message
                : LocaleKeys.no_pending_bookings.tr(),
            style: AppStyles.s14Medium.withColor(AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
