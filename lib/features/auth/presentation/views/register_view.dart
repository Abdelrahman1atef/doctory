import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../sections/register_body_section.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: RegisterBodySection(),
    );
  }
}

