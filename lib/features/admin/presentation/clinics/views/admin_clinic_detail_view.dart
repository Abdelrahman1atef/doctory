import 'package:flutter/material.dart';
import '../sections/admin_clinic_detail_body_section.dart';

class AdminClinicDetailView extends StatelessWidget {
  const AdminClinicDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminClinicDetailBodySection());
  }
}
