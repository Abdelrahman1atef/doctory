import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MapLocationFabWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Object? heroTag;

  const MapLocationFabWidget({
    super.key,
    required this.onPressed,
    this.heroTag = 'map_location_fab',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: AppColors.stitchSurfaceLowest,
      child: const Icon(
        Icons.my_location,
        color: AppColors.stitchPrimaryContainer,
      ),
    );
  }
}
