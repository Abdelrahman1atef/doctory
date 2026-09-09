import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Circular profile avatar for patients and clinic staff without a badge.
class HomeAvatarWidget extends StatelessWidget {
  final String? imageUrl;

  const HomeAvatarWidget({super.key, this.imageUrl});

  DecorationImage get _image {
    final String? url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(url.toImageUrl),
        fit: BoxFit.cover,
      );
    }
    return const DecorationImage(
      image: AssetImage('assets/images/avatar.jpg'),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.profile),
      child: Container(
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
          image: _image,
        ),
      ),
    );
  }
}
