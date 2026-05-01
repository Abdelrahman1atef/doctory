import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../sections/otp_body_section.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.stitchPrimary),
      ),
      body: OtpBodySection(
        email: email,
        isForgotPassword: isForgotPassword,
      ),
    );
  }
}

