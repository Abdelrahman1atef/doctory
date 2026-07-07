import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(imageUrl: imageUrl),
              ),
            ),
          ),
        ));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
