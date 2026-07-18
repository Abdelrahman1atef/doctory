import 'package:cached_network_image/cached_network_image.dart';
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
            backgroundImage: imageUrl != null && imageUrl!.isNotEmpty ? null : null,
            child: _buildAvatarContent(),
          ),
          if (showBadge)
            Positioned(
              bottom: -5,
              right: -5,
              child: Container(
                width: size * 0.5,
                height: size * 0.5,
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(
                  color: isFreelance == true ? AppColors.info : AppColors.stitchPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFreelance == true ? Icons.medical_information_outlined : Icons.local_hospital,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Icon(Icons.person, size: 28);
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset(
          'assets/images/app_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.person, size: 28),
      ),
    );
  }
}
