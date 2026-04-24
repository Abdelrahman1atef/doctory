import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/forgot_password_body_section.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.stitchPrimary),
        forceMaterialTransparency: true,
      ),
      body: const ForgotPasswordBodySection(),
    );
  }
}
