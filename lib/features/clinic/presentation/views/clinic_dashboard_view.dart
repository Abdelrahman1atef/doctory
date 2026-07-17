import 'package:flutter/material.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_body_section.dart';

class ClinicDashboardView extends StatelessWidget {
  const ClinicDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashboardBodySection(),
    );
  }
}
