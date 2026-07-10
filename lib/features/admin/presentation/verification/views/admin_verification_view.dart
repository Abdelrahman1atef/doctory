import 'package:flutter/material.dart';
import '../sections/admin_verification_body_section.dart';

class AdminVerificationView extends StatelessWidget {
  const AdminVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminVerificationBodySection());
  }
}
