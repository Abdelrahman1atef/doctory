import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WelcomeIllustrationWidget extends StatelessWidget {
  const WelcomeIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Background circular gradient (Soft Sanctuary feel)
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
                  AppColors.stitchSurface.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          /// Decorative floating dots
          Positioned(
            top: 20,
            left: 40,
            child: _CircleDot(
              color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.2),
              size: 12,
            ),
          ),
          Positioned(
            bottom: 40,
            right: 50,
            child: _CircleDot(color: AppColors.stitchSecondary.withValues(alpha: 0.1), size: 24),
          ),
          Positioned(
            top: 100,
            right: 30,
            child: _CircleDot(color: AppColors.stitchTertiary.withValues(alpha: 0.1), size: 16),
          ),

          /// Main Medical Icon Container (Glassmorphic)
          Hero(
            tag: 'app_logo',
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.stitchPrimary.withValues(alpha: 0.06),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.stitchPrimaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medical_services_rounded, size: 64, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleDot extends StatelessWidget {
  final Color color;
  final double size;

  const _CircleDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
