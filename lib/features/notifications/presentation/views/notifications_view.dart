import 'package:doctory/features/notifications/presentation/sections/notifications_body_section.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: NotificationsBodySection(),
      ),
    );
  }
}
