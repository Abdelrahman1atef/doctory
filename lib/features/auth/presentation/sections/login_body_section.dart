import 'package:flutter/material.dart';
import '../widgets/login_body_widget.dart';
import '../widgets/login_header_widget.dart';
import 'login_input_section.dart';

class LoginBodySection extends StatelessWidget {
  const LoginBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginBodyWidget(
      header: LoginHeaderWidget(),
      form: LoginInputSection(),
    );
  }
}

