import 'package:doctory/features/auth/presentation/sections/reset_password_page_body_section.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String token;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResetPasswordPageBodySection(email: email, token: token),
    );
  }
}
