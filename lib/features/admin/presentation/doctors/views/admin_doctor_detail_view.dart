import 'package:flutter/material.dart';
import '../sections/admin_doctor_detail_body_section.dart';

class AdminDoctorDetailView extends StatelessWidget {
  const AdminDoctorDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminDoctorDetailBodySection());
  }
}
