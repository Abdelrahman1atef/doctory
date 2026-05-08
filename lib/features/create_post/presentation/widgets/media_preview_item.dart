import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';
import 'package:flutter/material.dart';

class MediaPreviewItem extends StatelessWidget {
  final SelectedMediaModel media;
  final VoidCallback onRemove;

  final double width;
  final double height;
  final String? overlayText;

  const MediaPreviewItem({
    super.key,
    required this.media,
    required this.onRemove,
    this.width = double.infinity,
    this.height = double.infinity,
    this.overlayText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: AppColors.grey100),
            child: media.type == MediaType.image
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        media.file,
                        fit: BoxFit.cover,
                        cacheWidth: 800, // Optimize memory for previews
                      ),
                      if (media.isCompressing)
                        Container(
                          color: Colors.black26,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: Icon(
                      media.type == MediaType.video
                          ? Icons.videocam
                          : media.type == MediaType.audio
                          ? Icons.audiotrack
                          : Icons.insert_drive_file,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
          ),
          if (overlayText != null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  overlayText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
