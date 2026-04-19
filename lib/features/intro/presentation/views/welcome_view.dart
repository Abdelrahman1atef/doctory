import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/intro/presentation/sections/welcome_actions_section.dart';
import 'package:doctory/features/intro/presentation/sections/welcome_header_section.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              /// Header Section (Illustration, Title, Subtitle)
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: const WelcomeHeaderSection(),
              ),
              
              const Spacer(flex: 2),
              
              /// Actions Section (Buttons)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: const WelcomeActionsSection(),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
