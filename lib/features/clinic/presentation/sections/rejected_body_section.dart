import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class RejectedBodySection extends StatelessWidget {
  const RejectedBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 80,
              color: AppColors.errorColor,
            ),
            24.ph,
            Text(
              context.l10n('rejected_title'),
              style: AppStyles.s24Bold.copyWith(color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
            12.ph,
            Text(
              context.l10n('rejected_subtitle'),
              style: AppStyles.s16Medium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            32.ph,
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.l10n('back_to_home'),
                  style: AppStyles.s16SemiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
