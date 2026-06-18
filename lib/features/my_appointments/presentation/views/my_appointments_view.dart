import 'package:doctory/features/my_appointments/presentation/sections/my_appointments_body_section.dart';
import 'package:flutter/material.dart';

class MyAppointmentsView extends StatelessWidget {
  const MyAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MyAppointmentsBodySection(),
      ),
    );
  }
}
