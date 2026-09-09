import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/map_home/data/model/route_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';



class MapNavInfoWidget extends StatelessWidget {
  final ClinicModel clinic;
  final RouteModel route;
  final VoidCallback onStop;

  const MapNavInfoWidget({
    super.key,
    required this.clinic,
    required this.route,
    required this.onStop,
  });

  String _formatDistance(double meters, BuildContext context) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} ${'distance_km'.tr()}';
    }
    return '${meters.toInt()} ${'distance_m'.tr()}';
  }

  String _formatDuration(double seconds, BuildContext context) {
    final minutes = (seconds / 60).round();
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes > 0) {
        return '$hours${'duration_hour'.tr()} $remainingMinutes${'minutes_suffix'.tr()}';
      }
      return '$hours${'duration_hour'.tr()}';
    }
    return '$minutes ${'minutes_suffix'.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          color: AppColors.stitchSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
          child: const Icon(Icons.navigation, color: AppColors.stitchPrimaryContainer, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        clinic.displayName,
                        style: AppStyles.s14Bold.withColor(AppColors.stitchPrimaryContainer),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_car,
                            size: 14,
                            color: AppColors.stitchSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDistance(route.distance, context),
                            style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.stitchSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(route.duration, context),
                            style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: onStop,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    padding: const EdgeInsets.all(10),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
