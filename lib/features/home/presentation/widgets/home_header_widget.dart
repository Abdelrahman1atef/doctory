import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String? imageUrl;

  const HomeHeaderWidget({super.key, required this.userName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n('good_morning'),
              style: AppStyles.s14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n('hello_user', args: [userName]),
              style: AppStyles.s16Bold.copyWith(
                fontSize: 24,
                color: AppColors.stitchPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n('how_can_we_help'),
              style: AppStyles.s16Bold.copyWith(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.stitchSurface,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: (imageUrl != null && imageUrl!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(imageUrl!.toImageUrl),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage("assets/images/avatar.jpg"),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }
}
