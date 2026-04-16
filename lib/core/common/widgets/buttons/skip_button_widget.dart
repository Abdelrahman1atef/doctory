import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/theme/app_typography.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
    required this.color,
    required this.iconColor,
    this.onTap,
  });
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.go(""),
      child: Text(
        "onboarding.skip".tr(),
        style: AppStyles.s14Medium.copyWith(color: iconColor),
      ),
    );
  }
}
