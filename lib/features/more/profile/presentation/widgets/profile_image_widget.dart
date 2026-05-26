import 'dart:io';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? localImage;
  final VoidCallback onPickImage;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.localImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.grey100,
            backgroundImage: localImage != null
                ? FileImage(localImage!)
                : (imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!.toImageUrl)
                    : null) as ImageProvider?,
            child: localImage == null && (imageUrl == null || imageUrl!.isEmpty)
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.stitchPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
