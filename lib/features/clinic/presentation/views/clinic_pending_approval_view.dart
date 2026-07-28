import 'package:flutter/material.dart';
import '../sections/pending_approval_body_section.dart';

class ClinicPendingApprovalView extends StatelessWidget {
  const ClinicPendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PendingApprovalBodySection(),
      ),
    );
  }
}
