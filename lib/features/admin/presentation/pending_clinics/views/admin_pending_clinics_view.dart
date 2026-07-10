import 'package:flutter/material.dart';
import '../sections/admin_pending_clinics_body_section.dart';

class AdminPendingClinicsView extends StatelessWidget {
  const AdminPendingClinicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminPendingClinicsBodySection());
  }
}
