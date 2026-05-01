import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// Pure widget — displays the OTP screen layout with animations.
class OtpBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget form;

  const OtpBodyWidget({
    super.key,
    required this.header,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: header,
            ),
            const SizedBox(height: 60),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: form,
            ),
          ],
        ),
      ),
    );
  }
}
