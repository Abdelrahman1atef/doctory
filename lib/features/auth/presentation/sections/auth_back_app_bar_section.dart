import 'package:doctory/core/common/widgets/layout/back_header_widget.dart';
import 'package:flutter/material.dart';

/// Shared header for the auth flow screens — back button only.
class AuthBackAppBarSection extends StatelessWidget {
  const AuthBackAppBarSection({super.key});

  @override
  Widget build(BuildContext context) => const BackHeaderWidget();
}
