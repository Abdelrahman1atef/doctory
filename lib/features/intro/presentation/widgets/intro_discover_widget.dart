import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroDiscoverWidget extends StatelessWidget {
  const IntroDiscoverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Visual Component (Stitch Minimalist Style)
          SizedBox(
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Outer Soft Glow
                FadeIn(
                  duration: const Duration(milliseconds: 1500),
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.04),
                          blurRadius: 100,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // Layer 2: Geometric Background Circles
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.stitchPrimary.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // Layer 3: Main Icon Container
                ZoomIn(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.12),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 64,
                          color: AppColors.stitchPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          // Title
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.tr('welcome_discover_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.stitchPrimary,
                  height: 1.3,
                  fontFamily: 'Bukra',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Subtitle
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.tr('welcome_discover_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.stitchPrimary.withValues(alpha: 0.6),
                  height: 1.6,
                  fontFamily: 'Bukra',
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
