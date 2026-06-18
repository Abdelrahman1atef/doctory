import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionContainerWidget extends StatelessWidget {
  final Widget child;

  const SectionContainerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.3)),
      ),
      child: child,
    );
  }
}
