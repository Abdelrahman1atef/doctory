import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AdsActiveTagWidget extends StatelessWidget {
  const AdsActiveTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'ads_active_tag'.tr(),
        style: AppStyles.s10Bold.copyWith(color: AppColors.success),
      ),
    );
  }
}