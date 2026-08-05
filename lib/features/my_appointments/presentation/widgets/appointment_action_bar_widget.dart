import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentActionBarWidget extends StatelessWidget {
  final VoidCallback? onPayTap;
  final VoidCallback? onCancelTap;
  final bool isCancelling;

  const AppointmentActionBarWidget({
    super.key,
    this.onPayTap,
    this.onCancelTap,
    this.isCancelling = false,
  });

  bool get _canPay => onPayTap != null;
  bool get _canCancel => onCancelTap != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        border: const Border(
          top: BorderSide(color: AppColors.stitchSurfaceLow),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_canPay) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPayTap,
                icon: const Icon(Icons.payment),
                label: Text('pay_now'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  foregroundColor: AppColors.stitchSurfaceLowest,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppStyles.s16Bold,
                ),
              ),
            ),
          ],
          if (_canPay && _canCancel) 12.ph,
          if (_canCancel) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    isCancelling ? null : onCancelTap,
                icon: const Icon(Icons.cancel_outlined),
                label: Text('cancel_appointment'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: isCancelling
                        ? AppColors.error.withValues(alpha: 0.4)
                        : AppColors.error,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}