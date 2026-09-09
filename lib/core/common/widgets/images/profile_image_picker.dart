import 'dart:io';

import 'package:flutter/material.dart';
import '../../../services/media/alert_of_media.dart';
import '../../../theme/app_colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImagePicked;

  const ProfileImagePicker({
    super.key,
    required this.imageFile,
    required this.onImagePicked,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AlertOfMedia(
        onCameraSelected: (file) {
          if (file != null) onImagePicked(file);
        },
        onGallerySelected: (file) {
          if (file != null) onImagePicked(file);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _showPicker(context),
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.stitchSurfaceLow,
                border: Border.all(color: AppColors.cardBorder, width: 2),
                image: imageFile != null
                    ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageFile == null
                  ? const Icon(
                      Icons.person_outline_rounded,
                      size: 56,
                      color: AppColors.textHint,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
