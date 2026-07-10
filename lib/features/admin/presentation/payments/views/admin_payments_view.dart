import 'package:flutter/material.dart';
import '../sections/admin_payments_body_section.dart';

class AdminPaymentsView extends StatelessWidget {
  const AdminPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminPaymentsBodySection());
  }
}
