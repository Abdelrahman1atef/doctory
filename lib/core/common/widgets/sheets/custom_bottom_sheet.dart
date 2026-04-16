import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget actionButton;

  const CustomBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: context.bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          10.ph,
          Text(
            title,
            style: AppStyles.s18Bold.withColor(AppColors.primaryNavy),
          ),
          if (subtitle != null) ...[
            8.ph,
            Text(
              subtitle!,
              style: AppStyles.s14Medium.withColor(AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
          32.ph,
          content,
          32.ph,
          actionButton,
        ],
      ),
    );
  }
}
