import 'package:doctory/features/auth/presentation/sections/auth_back_app_bar_section.dart';
import 'package:doctory/features/auth/presentation/sections/otp_body_section.dart';
import 'package:flutter/material.dart';

class OtpPageBodySection extends StatelessWidget {
  final String? email;
  final bool isForgotPassword;

  const OtpPageBodySection({
    super.key,
    this.email,
    this.isForgotPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AuthBackAppBarSection(),
        Expanded(
          child: OtpBodySection(
            email: email,
            isForgotPassword: isForgotPassword,
          ),
        ),
      ],
    );
  }
}
