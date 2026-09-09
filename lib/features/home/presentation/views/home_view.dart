import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/home/presentation/sections/home_body_section.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: HomeBodySection(),
    );
  }
}
