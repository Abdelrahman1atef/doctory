import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ClinicCardImageWidget extends StatelessWidget {
  final String? imageUrl;

  const ClinicCardImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl ?? '',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 80,
          color: AppColors.stitchSurfaceLow,
          child: const Icon(
            Icons.local_hospital,
            color: AppColors.stitchSecondary,
          ),
        ),
      ),
    );
  }
}
