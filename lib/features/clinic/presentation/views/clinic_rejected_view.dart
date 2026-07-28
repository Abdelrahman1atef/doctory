import 'package:flutter/material.dart';
import '../sections/rejected_body_section.dart';

class ClinicRejectedView extends StatelessWidget {
  const ClinicRejectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: RejectedBodySection(),
      ),
    );
  }
}
