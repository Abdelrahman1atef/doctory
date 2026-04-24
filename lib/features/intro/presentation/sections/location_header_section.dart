import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationHeaderSection extends StatelessWidget {
  const LocationHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Illustration (Glassmorphic Location Pin)
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
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
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 64,
                  color: AppColors.stitchPrimary,
                ),
              ),

              /// Decorative pulses
              ...List.generate(2, (index) => _PulseCircle(delay: index * 400)),
            ],
          ),
        ),

        const SizedBox(height: 48),

        /// Title
        Text(
          context.tr('location_access_title'),
          textAlign: TextAlign.center,
          style: AppStyles.s26Bold.copyWith(
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 16),

        /// Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            context.tr('location_access_subtitle'),
            textAlign: TextAlign.center,
            style: AppStyles.s16Medium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseCircle extends StatelessWidget {
  final int delay;
  const _PulseCircle({required this.delay});

  @override
  Widget build(BuildContext context) {
    // Note: Simplification - we could use animation but for now we'll just show the static circles
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.stitchPrimary.withValues(alpha: 0.05),
          width: 2,
        ),
      ),
    );
  }
}
