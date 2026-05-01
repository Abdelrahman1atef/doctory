import 'package:flutter/material.dart';

/// Pure widget — provides a scrolling container with standard padding for Auth forms.
class AuthFormContainerWidget extends StatelessWidget {
  final Widget child;

  const AuthFormContainerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: child,
    );
  }
}
