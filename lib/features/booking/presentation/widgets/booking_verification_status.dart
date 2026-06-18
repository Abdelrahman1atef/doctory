import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingVerificationLoading extends StatelessWidget {
  const BookingVerificationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          Text(
            'verifying_payment'.tr(),
            style: AppStyles.s16Medium.withColor(AppColors.stitchPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            'please_wait'.tr(),
            style: AppStyles.s14Medium.withColor(AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class BookingVerificationError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BookingVerificationError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'payment_failed'.tr(),
              style: AppStyles.s20Bold.withColor(AppColors.error),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppStyles.s14Medium.withColor(AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: Text('try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingVerificationSuccess extends StatelessWidget {
  const BookingVerificationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'payment_processed'.tr(),
            style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            'confirm_payment_to_finish'.tr(),
            style: AppStyles.s14Medium.withColor(AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
