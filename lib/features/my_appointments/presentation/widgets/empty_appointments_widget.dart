import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyAppointmentsWidget extends StatelessWidget {
  const EmptyAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.event_busy_rounded,
          size: 64,
          color: AppColors.grey400,
        ),
        16.ph,
        Text(
          'no_appointments'.tr(),
          style: AppStyles.s16Medium.withColor(
            AppColors.stitchSecondary,
          ),
        ),
      ],
    );
  }
}