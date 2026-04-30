import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/login_header_widget.dart';
import 'login_input_section.dart';

class LoginBodySection extends StatelessWidget {
  const LoginBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              40.ph,

              /// Header Section
              const LoginHeaderWidget(),

              80.ph,

              /// Input Section
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: const LoginInputSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
