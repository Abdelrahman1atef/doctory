import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Page header used by the Stitch-styled onboarding screens: optional back
/// arrow, a large title and a muted subtitle.
class StitchPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const StitchPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null) ...[
            GestureDetector(
              onTap: onBack,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
            16.pw,
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(
            title,
            style: AppStyles.s24Bold.copyWith(color: AppColors.onSurface),
          ),
          if (subtitle != null) ...[
            8.ph,
            Text(
              subtitle!,
              style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
            ),
          ],

            ],
          )
        ],
      ),
    );
  }
}
