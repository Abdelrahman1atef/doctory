import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingTimerBanner extends StatelessWidget {
  final int minutes;
  final int seconds;

  const BookingTimerBanner({
    super.key,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.warning, size: 22),
          10.pw,
          Expanded(
            child: Text(
              'reservation_expires_in'.tr(
                namedArgs: {
                  'minutes': minutes.toString(),
                  'seconds': seconds.toString(),
                },
              ),
              style: AppStyles.s14Medium.withColor(AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
