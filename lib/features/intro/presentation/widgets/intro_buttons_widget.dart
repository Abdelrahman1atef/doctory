import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/app_strings/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroButtonsWidget extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const IntroButtonsWidget({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: isLastPage
          ? CustomButton(
              onPressed: onStart,
              text: AppStrings.startNow.tr(),
              backgroundColor: AppColors.primaryTeal,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(50),
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: AppStyles.s16Bold.copyWith(color: AppColors.white),
            )
          : CustomButton.outlined(
              onPressed: onNext,
              text: AppStrings.next.tr(),
              borderColor: AppColors.primaryTeal,
              textColor: AppColors.primaryTeal,
              borderRadius: BorderRadius.circular(50),
              trailingIcon: const Icon(
                Icons.arrow_forward,
                size: 20,
                color: AppColors.primaryTeal,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: AppStyles.s14Bold.copyWith(
                color: AppColors.primaryTeal,
              ),
            ),
    );
  }
}
