import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessView extends StatelessWidget {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 80,
                ),
              ),
              32.ph,
              Text(
                'booking_success'.tr(),
                style: AppStyles.s24Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              16.ph,
              Text(
                'booking_success_desc'.tr(),
                style: AppStyles.s16Medium
                    .withColor(AppColors.stitchSecondary)
                    .copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.mapHome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stitchPrimaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'back_to_home'.tr(),
                    style: AppStyles.s16Bold.withColor(
                      AppColors.stitchSurfaceLowest,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
