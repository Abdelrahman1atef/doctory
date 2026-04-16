import 'package:doctory/features/auth/presentation/sections/login_body_section.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginBodySection());
  }
}
