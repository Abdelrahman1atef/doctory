import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpHeaderSection extends StatelessWidget {
  final String? email;
  const OtpHeaderSection({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Symbol/Icon (Minimalist)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 48,
            color: AppColors.stitchPrimary,
          ),
        ),
        
        const SizedBox(height: 32),
        
        /// Title
        Text(
          context.tr('otp'),
          textAlign: TextAlign.center,
          style: AppStyles.s26Bold.copyWith(
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 12),
        
        /// Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppStyles.s16Medium.copyWith(color: AppColors.textSecondary, height: 1.5),
              children: [
                TextSpan(text: context.tr('verification_sent_to_email')),
                TextSpan(
                  text: email ?? context.tr('email'),
                  style: AppStyles.s16Bold.copyWith(color: AppColors.onSurface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
