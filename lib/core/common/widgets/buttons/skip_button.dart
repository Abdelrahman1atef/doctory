import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/theme/app_colors.dart';

class SkipTextButton extends StatelessWidget {
  const SkipTextButton({super.key, this.onTap, this.color});

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.go(AppRoutes.login),
      child: Text(
        "onboarding.skip".tr(),
        style: AppStyles.s14Medium.copyWith(color: color ?? AppColors.primary),
      ),
    );
  }
}
