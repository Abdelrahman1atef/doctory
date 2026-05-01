import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Pure widget — displays error message for Home screen.
class HomeErrorWidget extends StatelessWidget {
  final String message;

  const HomeErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: AppStyles.s16Bold.copyWith(color: AppColors.errorColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
