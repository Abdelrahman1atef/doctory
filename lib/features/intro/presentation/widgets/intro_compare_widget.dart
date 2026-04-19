import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroCompareWidget extends StatelessWidget {
  const IntroCompareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual
          SizedBox(
            height: 360,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Outer Soft Glow
                FadeIn(
                  duration: const Duration(milliseconds: 1500),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.05),
                          blurRadius: 80,
                        ),
                      ],
                    ),
                  ),
                ),
                // Circular Image
                ZoomIn(
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.stitchPrimary.withValues(alpha: 0.06),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdAZnalfVwPC7_cHLZlyILZI1NP9kFmbZDAw2UEc_BK8Iqz56EbobExmpqkYEtD4pl0F45SMnpxGIzQLNPaqNQmgnKunau5RbPBWnIEfnzwYW_cHtCrHMZln2sG0NVp21DaMPWFOiLg8oLeH2ixjAfBgdoouAx_QBO9bcFPgZRvTJYrxg6aQJIrvyZgpnrpNjlRccfyyr0eL9fzcT3d7Xl43FNYuYHvsCrrTCphw5iU9FPqsVn7Iquts1pw8EJ1PkJas-K8aOGkKE',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Floating Badge 1 (Distance)
                Positioned(
                  top: 40,
                  left: 10,
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: _buildBadge(
                      context: context,
                      icon: Icons.location_on,
                      title: context.tr('welcome_compare_distance'),
                      value: '1.2 km',
                      iconBg: AppColors.stitchPrimaryContainer,
                      iconColor: Colors.white,
                      valueColor: AppColors.stitchPrimary,
                    ),
                  ),
                ),
                // Floating Badge 2 (Rating)
                Positioned(
                  bottom: 40,
                  right: 10,
                  child: FadeInRight(
                    delay: const Duration(milliseconds: 600),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 3 * (value - 0.5)),
                          child: child,
                        );
                      },
                      child: _buildBadge(
                        context: context,
                        icon: Icons.star,
                        title: context.tr('welcome_compare_rating'),
                        value: '4.9 / 5.0',
                        iconBg: AppColors.spicalColor.withValues(alpha: 0.15),
                        iconColor: AppColors.spicalColor,
                        valueColor: AppColors.rate,
                      ),
                    ),
                  ),
                ),
                // Floating Badge 3 (Availability)
                Positioned(
                  top: 160,
                  right: 0,
                  child: FadeInRight(
                    delay: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.stitchPrimary.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.tr('welcome_compare_available'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bukra',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          // Title
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.tr('welcome_compare_title'),
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
                context.tr('welcome_compare_subtitle'),
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

  Widget _buildBadge({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color iconBg,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.stitchPrimary.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Bukra',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                  fontFamily: 'Bukra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
