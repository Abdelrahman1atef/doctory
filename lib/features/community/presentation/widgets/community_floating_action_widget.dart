import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommunityFloatingActionWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CommunityFloatingActionWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'community_fab',
      onPressed: onPressed,
      backgroundColor: AppColors.stitchPrimary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
