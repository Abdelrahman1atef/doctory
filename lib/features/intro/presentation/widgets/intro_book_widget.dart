import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_assets.dart';

class IntroBookWidget extends StatelessWidget {
  const IntroBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual Area
          SizedBox(
            height: 340,
            child: Card(
              elevation: 5,
              child: AppAssets.image(
                Utils.lang == 'ar'
                    ? AppAssets.images.bookingAr
                    : AppAssets.images.bookingEn,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 60),
          // Title
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.tr('welcome_go_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.stitchPrimary,
                  height: 1.3,
                  fontFamily: 'Bukra',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Subtitle
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.tr('welcome_go_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.stitchPrimary.withValues(alpha: 0.6),
                  height: 1.6,
                  fontFamily: 'Bukra',
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
