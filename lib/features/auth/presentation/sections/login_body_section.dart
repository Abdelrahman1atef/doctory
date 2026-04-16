import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/auth/presentation/sections/login_input_section.dart';
import 'package:flutter/material.dart';

class LoginBodySection extends StatelessWidget {
  const LoginBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          100.ph,
          // Logo or Illustration
          Image.asset(AppAssets.images.appLogo, height: 120),
          40.ph,
          Text(
            'Welcome to Doctory',
            style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.primaryColor,
            ),
          ),
          8.ph,
          Text(
            'Please login to your account',
            style: context.theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          40.ph,
          const LoginInputSection(),
        ],
      ),
    );
  }
}
