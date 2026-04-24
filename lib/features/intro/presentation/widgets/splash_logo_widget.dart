import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SplashLogoWidget extends StatefulWidget {
  const SplashLogoWidget({super.key});

  @override
  State<SplashLogoWidget> createState() => _SplashLogoWidgetState();
}

class _SplashLogoWidgetState extends State<SplashLogoWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: AppColors.stitchSurface),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Animated Tonal Glows (Soft Background)
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -50 + (20 * _glowController.value),
                    right: -50 + (20 * _glowController.value),
                    child: _GlowCircle(
                      color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
                      size: 300,
                    ),
                  ),
                  Positioned(
                    bottom: -30 + (30 * (1 - _glowController.value)),
                    left: -40 + (30 * _glowController.value),
                    child: _GlowCircle(
                      color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
                      size: 250,
                    ),
                  ),
                ],
              );
            },
          ),

          /// Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              /// Logo with ZoomIn animation
              ZoomIn(
                duration: const Duration(milliseconds: 1000),
                child: Hero(
                  tag: 'app_logo',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: 160,
                      height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.08),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: AppColors.stitchPrimaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),),

              const SizedBox(height: 48),

              /// App Name with FadeInDown
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Doctory',
                  style: AppStyles.s32Bold.copyWith(
                    color: AppColors.stitchPrimary,
                    letterSpacing: -1,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Slogan with FadeInUp
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Your Clinical Sanctuary',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.textSecondary),
                ),
              ),

              const Spacer(),

              /// Loading Dots (Pulsing)
              FadeIn(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 800),
                child: const _LoadingDots(),
              ),

              const SizedBox(height: 64),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return FadeIn(
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: index * 200),
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              color: AppColors.stitchPrimaryContainer,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
