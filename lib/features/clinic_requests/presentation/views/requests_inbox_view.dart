import 'package:doctory/features/clinic_requests/presentation/sections/requests_body_section.dart';
import 'package:flutter/material.dart';

class RequestsInboxView extends StatelessWidget {
  const RequestsInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'طلبات الحجز',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: RequestsBodySection(),
            ),
          ],
        ),
      ),
    );
  }
}
