import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/profile_form_section.dart';
import 'package:doctory/features/auth/presentation/sections/profile_header_section.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              /// Header Section
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: const ProfileHeaderSection(),
              ),
              
              const SizedBox(height: 48),
              
              /// Form Section
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: const ProfileFormSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
