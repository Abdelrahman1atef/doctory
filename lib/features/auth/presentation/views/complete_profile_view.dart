import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../sections/profile_body_section.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: ProfileBodySection(),
    );
  }
}

