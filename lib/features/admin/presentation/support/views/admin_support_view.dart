import 'package:flutter/material.dart';
import '../sections/admin_support_body_section.dart';

class AdminSupportView extends StatelessWidget {
  const AdminSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminSupportBodySection());
  }
}
