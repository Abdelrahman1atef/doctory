import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class DoctorAvatarBadge extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final bool showBadge;
  final bool? isFreelance;

  const DoctorAvatarBadge({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.onTap,
    this.showBadge = true,
    this.isFreelance,
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
            backgroundImage:
                imageUrl != null && imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          if (showBadge)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: size / 3.2,
                height: size / 3.2,
                decoration: BoxDecoration(
                  color: isFreelance == true ? AppColors.warning : AppColors.stitchPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFreelance == true ? Icons.person_pin : Icons.local_hospital,
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
