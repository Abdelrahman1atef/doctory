import 'dart:ui';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MapSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onFilterTap;

  const MapSearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest, // Removed transparency/blur to save performance over map
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.stitchSurfaceLowest.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.stitchSecondary),
          12.pw,
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: AppStyles.s14Medium.withColor(
                AppColors.stitchSecondary,
              ),
              decoration: InputDecoration(
                hintText: 'search'.tr(),
                hintStyle: AppStyles.s14Medium.withColor(
                  AppColors.stitchSecondary.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          InkWell(
            onTap: onFilterTap,
            child: const Icon(
              Icons.tune,
              color: AppColors.stitchPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
