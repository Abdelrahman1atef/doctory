import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class BookingSectionHeader extends StatelessWidget {
  final String title;

  /// Optional: omitted when the section body already explains itself.
  final String? subtitle;

  const BookingSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: AppStyles.s14Medium.withColor(AppColors.grey500),
          ),
        ],
      ],
    );
  }
}
