import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/reset_password_body_section.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String token;
  const ResetPasswordView({super.key, required this.email, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.stitchPrimary),
        forceMaterialTransparency: true,
      ),
      body: ResetPasswordBodySection(email: email, token: token),
    );
  }
}
