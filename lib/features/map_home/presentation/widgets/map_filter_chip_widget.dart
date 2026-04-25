import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class MapFilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MapFilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryContainer
              : AppColors.stitchSurfaceLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.stitchPrimaryContainer
                : AppColors.stitchSurfaceLow,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: AppStyles.s14Medium.withColor(
            isSelected
                ? AppColors.stitchSurfaceLowest
                : AppColors.stitchSecondary,
          ),
        ),
      ),
    );
  }
}
