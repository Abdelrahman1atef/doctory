import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/intro/data/model/intro_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroItemWidget extends StatelessWidget {
  final IntroModel intro;

  const IntroItemWidget({super.key, required this.intro});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(120.0),
            child: Transform.scale(
              scale: 2.0,
              child: AppAssets.svg(intro.imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
        20.ph,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            intro.title.tr(),
            style: AppStyles.s16Bold.withColor(AppColors.primaryNavy),
            textAlign: TextAlign.center,
          ),
        ),
        20.ph,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70.0),
          child: Text(
            intro.content.tr(),
            style: AppTextSizes.s14.regular.withColor(AppColors.grey4),
            textAlign: TextAlign.center,
          ),
        ),
        60.ph, // To avoid overlapping with bottom controls
      ],
    );
  }
}
