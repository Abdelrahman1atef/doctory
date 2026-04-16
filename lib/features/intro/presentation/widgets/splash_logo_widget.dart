import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        image: DecorationImage(
          image: AssetImage(AppAssets.images.splash),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: AppAssets.svg(AppAssets.images.logoSvg, width: 180, height: 180),
      ),
    );
  }
}
