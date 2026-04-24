import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LocationActionsSection extends StatelessWidget {
  const LocationActionsSection({super.key});

  Future<void> _handlePermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && context.mounted) {
      SmartDialog.showToast(context.tr('location_services_disabled'));
      // We could ask user to enable it, but for now we continue
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          SmartDialog.showToast(context.tr('location_permission_denied'));
          context.go(AppRoutes.mainLayout);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        SmartDialog.showToast(context.tr('location_permission_permanently_denied'));
        context.go(AppRoutes.mainLayout);
      }
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      SmartDialog.showLoading();
      Position position = await Geolocator.getCurrentPosition();
      await CacheHelper.saveDouble('lat', position.latitude);
      await CacheHelper.saveDouble('lng', position.longitude);
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      // Silently fail or show toast
    }

    if (context.mounted) {
      context.go(AppRoutes.mainLayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Primary CTA (Allow Access)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _handlePermission(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stitchPrimaryContainer,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.tr('allow_location'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Secondary CTA (Not now)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: () {
              context.go(AppRoutes.mainLayout);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.stitchPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.tr('not_now'), style: AppStyles.s16SemiBold),
          ),
        ),
      ],
    );
  }
}
