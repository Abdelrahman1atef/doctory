import 'package:doctory/core/app_strings/app_strings.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroSkipButtonWidget extends StatelessWidget {
  final VoidCallback onSkip;

  const IntroSkipButtonWidget({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: TextButton(
        onPressed: onSkip,
        child: Text(
          AppStrings.skip.tr(),
          style: AppStyles.s14Medium.withColor(AppColors.grey4),
        ),
      ),
    );
  }
}
