import 'dart:math';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroBookWidget extends StatelessWidget {
  const IntroBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual Area
          SizedBox(
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decorative Blobs
                Positioned(
                  top: 0,
                  right: 20,
                  child: FadeInRight(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FadeInLeft(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Calendar view pseudo widget
                Positioned(
                  top: 20,
                  left: 60,
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 6 * (value - 0.5)),
                          child: child,
                        );
                      },
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Container(
                          width: 160,
                          height: 180,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.stitchPrimary.withValues(alpha: 0.06),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: AppColors.stitchPrimaryFixed,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                      ),
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: index == 8
                                            ? AppColors.stitchPrimaryContainer
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.stitchSurface,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Doctor card snippet
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 600),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 4),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, -6 * (value - 0.5)),
                          child: child,
                        );
                      },
                      child: Transform.rotate(
                        angle: 0.05,
                        child: Container(
                          width: 200,
                          height: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.stitchPrimary.withValues(alpha: 0.08),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAlwp2FrO6bABr_Nj5VwRqXyOIpfGxSDa6Ub9mIuEBR0em6GeCOm7UkSrcmhsFGDocj3nZB8BVxDN6ZNy4WlADP09tFd45uF4yQVKs4ZBJYYVlfJRDCWIBOlCBC4CqSeI6DC-ZOpoFEkYbtPj1Vz4jnF-WdW-9ZGI910yylCWZJZpO40__uPgcdATnqFGQYku2uNCxwPtJ0v_hCbRGF207EXvYRyATiw7OU2vKFWkOU268aRF_m_Xp3gFcYtDqDI0U-RFoI6R8Ho1g',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 40,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.stitchPrimary,
                                      AppColors.stitchPrimaryContainer,
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Large success checkmark
                ZoomIn(
                  delay: const Duration(milliseconds: 900),
                  duration: const Duration(milliseconds: 800),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 2500),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 4 * (value - 0.5)),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 48,
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
                context.tr('welcome_go_title'),
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
                context.tr('welcome_go_subtitle'),
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
