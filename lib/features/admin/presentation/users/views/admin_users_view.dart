import 'package:flutter/material.dart';
import '../sections/admin_users_body_section.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminUsersBodySection());
  }
}
