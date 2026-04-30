import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthBackgroundWidget extends StatelessWidget {
  final Widget child;
  const AuthBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.stitchSurface,
      child: Stack(
        children: [
          /// Tonal Background Layering (Minimalist)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
