import 'package:doctory/features/auth/presentation/sections/auth_back_app_bar_section.dart';
import 'package:doctory/features/auth/presentation/sections/forgot_password_body_section.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPageBodySection extends StatelessWidget {
  const ForgotPasswordPageBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AuthBackAppBarSection(),
        Expanded(child: ForgotPasswordBodySection()),
      ],
    );
  }
}
