import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroIndicatorWidget extends StatelessWidget {
  final PageController pageController;
  final int count;

  const IntroIndicatorWidget({
    super.key,
    required this.pageController,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SmoothPageIndicator(
        controller: pageController,
        count: count,
        effect: const WormEffect(
          activeDotColor: AppColors.primaryTeal,
          dotColor: AppColors.grey300,
          dotHeight: 12,
          dotWidth: 12,
        ),
      ),
    );
  }
}
