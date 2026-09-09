import 'package:doctory/features/auth/presentation/sections/auth_back_app_bar_section.dart';
import 'package:doctory/features/auth/presentation/sections/reset_password_body_section.dart';
import 'package:flutter/material.dart';

class ResetPasswordPageBodySection extends StatelessWidget {
  final String email;
  final String token;

  const ResetPasswordPageBodySection({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AuthBackAppBarSection(),
        Expanded(
          child: ResetPasswordBodySection(email: email, token: token),
        ),
      ],
    );
  }
}
