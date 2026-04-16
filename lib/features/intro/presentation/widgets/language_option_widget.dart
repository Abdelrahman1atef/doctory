import 'dart:ui' as ui;

import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class LanguageOptionWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.lightWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Row(
            children: [
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.primaryTeal,
                    size: 16,
                  ),
                )
              else
                24.ph,
              Expanded(
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: AppTextSizes.s14.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              24.ph,
            ],
          ),
        ),
      ),
    );
  }
}
