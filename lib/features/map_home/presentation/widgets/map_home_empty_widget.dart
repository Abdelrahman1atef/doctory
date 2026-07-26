import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MapHomeEmptyWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const MapHomeEmptyWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: AppColors.stitchSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'no_results'.tr(),
                style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'try_expand_radius'.tr(),
                style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  label: Text(
                    'retry'.tr(),
                    style: AppStyles.s14Bold.withColor(Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stitchPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
