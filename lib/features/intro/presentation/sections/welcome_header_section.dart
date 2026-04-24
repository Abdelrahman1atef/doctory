import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/intro/presentation/widgets/welcome_illustration_widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeHeaderSection extends StatelessWidget {
  const WelcomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Illustration Widget
        const WelcomeIllustrationWidget(),

        const SizedBox(height: 48),

        /// Headline (Editorial style)
        Text(
          context.tr('welcome_title'),
          textAlign: TextAlign.center,
          style: AppStyles.s32Bold.copyWith(
            color: AppColors.onSurface,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 16),

        /// Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            context.tr('welcome_subtitle'),
            textAlign: TextAlign.center,
            style: AppStyles.s16Medium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
