import 'package:flutter/material.dart';
import '../sections/admin_subscriptions_body_section.dart';

class AdminSubscriptionsView extends StatelessWidget {
  const AdminSubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminSubscriptionsBodySection());
  }
}
