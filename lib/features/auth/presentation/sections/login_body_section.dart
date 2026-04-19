import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/auth/presentation/sections/login_input_section.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LoginBodySection extends StatelessWidget {
  const LoginBodySection({super.key});

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
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  40.ph,
                  
                  /// Header Section
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.stitchPrimary,
                            fontSize: 32,
                            height: 1.2,
                          ),
                        ),
                        16.ph,
                        Text(
                          'Log in to access your clinical sanctuary.',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  80.ph,
                  
                  /// Input Section
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: const LoginInputSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
