import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdsIndicatorDotsWidget extends StatelessWidget {
  final int totalDots;
  final int activeDot;

  const AdsIndicatorDotsWidget({
    super.key,
    required this.totalDots,
    required this.activeDot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.stitchPrimary : AppColors.borderGrey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}