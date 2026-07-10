import 'package:flutter/material.dart';
import '../sections/admin_profile_body_section.dart';

class AdminProfileView extends StatelessWidget {
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminProfileBodySection());
  }
}
