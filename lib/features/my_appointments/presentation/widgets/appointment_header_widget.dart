import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AppointmentHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const AppointmentHeaderWidget({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.stitchPrimaryContainer,
              ),
              onPressed: onBack,
            ),
          const Spacer(),
          Text(
            title,
            style: AppStyles.s20Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
          const Spacer(),
          if (onBack != null) const SizedBox(width: 48),
        ],
      ),
    );
  }
}