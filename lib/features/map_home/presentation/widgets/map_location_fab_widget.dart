import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MapLocationFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const MapLocationFabWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'map_location_fab',
      onPressed: onPressed,
      backgroundColor: AppColors.stitchSurfaceLowest,
      child: const Icon(
        Icons.my_location,
        color: AppColors.stitchPrimaryContainer,
      ),
    );
  }
}
