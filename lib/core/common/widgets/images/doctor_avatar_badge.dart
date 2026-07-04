import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class DoctorAvatarBadge extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const DoctorAvatarBadge({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: size / 3.2,
              height: size / 3.2,
              decoration: const BoxDecoration(
                color: AppColors.stitchPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
