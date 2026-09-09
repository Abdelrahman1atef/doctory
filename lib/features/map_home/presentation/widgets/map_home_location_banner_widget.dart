import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MapHomeLocationBannerWidget extends StatelessWidget {
  final VoidCallback onEnableTap;

  const MapHomeLocationBannerWidget({
    super.key,
    required this.onEnableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, // Roughly below the search bar
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_off, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'enable_location_banner_msg'.tr(),
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: onEnableTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.stitchPrimaryContainer,
              ),
              child: Text('enable'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
