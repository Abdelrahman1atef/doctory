import 'package:animate_do/animate_do.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'auth_background_widget.dart';

/// Pure widget — displays the Login screen layout with animations.
class LoginBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget form;

  const LoginBodyWidget({super.key, required this.header, required this.form});

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
              header,
              80.ph,
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: form,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
