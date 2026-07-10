import 'package:flutter/material.dart';
import '../sections/admin_clinics_body_section.dart';

class AdminClinicsView extends StatelessWidget {
  const AdminClinicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminClinicsBodySection());
  }
}
