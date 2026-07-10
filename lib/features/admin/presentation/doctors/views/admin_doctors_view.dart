import 'package:flutter/material.dart';
import '../sections/admin_doctors_body_section.dart';

class AdminDoctorsView extends StatelessWidget {
  const AdminDoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminDoctorsBodySection());
  }
}
