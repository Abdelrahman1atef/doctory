import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/otp_page_body_section.dart';
import 'package:flutter/material.dart';

class OtpVerificationView extends StatelessWidget {
  final String? email;
  final bool isForgotPassword;

  const OtpVerificationView({
    super.key,
    this.email,
    this.isForgotPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: OtpPageBodySection(
        email: email,
        isForgotPassword: isForgotPassword,
      ),
    );
  }
}
