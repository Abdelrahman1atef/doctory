import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class BookingTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const BookingTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryFixed.withValues(alpha: 0.15)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.stitchPrimary : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                color: isSelected ? AppColors.white : AppColors.grey600,
                size: 24,
              ),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: AppStyles.s16Bold.withColor(
                      isSelected ? AppColors.stitchPrimary : AppColors.stitchPrimaryContainer,
                    ),
                  ),
                  4.ph,
                  Text(subtitle,
                    style: AppStyles.s13Medium.withColor(AppColors.grey500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.stitchPrimary, size: 22),
          ],
        ),
      ),
    );
  }
}
