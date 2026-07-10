import 'package:flutter/material.dart';
import '../sections/admin_specializations_body_section.dart';

class AdminSpecializationsView extends StatelessWidget {
  const AdminSpecializationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminSpecializationsBodySection());
  }
}
