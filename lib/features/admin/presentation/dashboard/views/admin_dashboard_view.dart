import 'package:flutter/material.dart';
import '../sections/admin_dashboard_body_section.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminDashboardBodySection());
  }
}
