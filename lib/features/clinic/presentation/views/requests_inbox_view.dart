import 'package:doctory/features/clinic/presentation/sections/requests_body_section.dart';
import 'package:flutter/material.dart';

class RequestsInboxView extends StatelessWidget {
  const RequestsInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: RequestsBodySection(),
      ),
    );
  }
}
