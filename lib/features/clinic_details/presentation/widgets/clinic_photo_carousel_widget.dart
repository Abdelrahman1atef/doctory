import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ClinicPhotoCarouselWidget extends StatefulWidget {
  final List<String> photos;

  const ClinicPhotoCarouselWidget({super.key, required this.photos});

  @override
  State<ClinicPhotoCarouselWidget> createState() =>
      _ClinicPhotoCarouselWidgetState();
}

class _ClinicPhotoCarouselWidgetState extends State<ClinicPhotoCarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.photos[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.stitchSurfaceLow,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: AppColors.stitchSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Indicators
        Positioned(
          bottom: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.photos.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.stitchPrimaryContainer
                      : AppColors.stitchSurfaceLowest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
