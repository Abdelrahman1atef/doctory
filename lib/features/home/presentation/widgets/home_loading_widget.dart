import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Pure widget — displays loading indicator for Home screen.
class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.stitchPrimary,
      ),
    );
  }
}
