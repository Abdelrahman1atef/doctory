import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          Text(
            context.l10n('login_title'),
            textAlign: TextAlign.center,
            style: AppStyles.s14Bold.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.stitchPrimary,
              fontSize: 32,
              height: 1.2,
            ),
          ),
          16.ph,
          Text(
            context.l10n('login_subtitle'),
            textAlign: TextAlign.center,
            style: AppStyles.s14Bold.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
