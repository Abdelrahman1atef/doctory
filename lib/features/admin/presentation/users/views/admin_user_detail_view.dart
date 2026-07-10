import 'package:flutter/material.dart';
import '../sections/admin_user_detail_body_section.dart';

class AdminUserDetailView extends StatelessWidget {
  const AdminUserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminUserDetailBodySection());
  }
}
