import 'package:doctory/features/my_appointments/presentation/sections/appointment_details_section.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsView extends StatelessWidget {
  final String? appointmentId;
  final String? paymentUrl;

  const AppointmentDetailsView({
    super.key,
    this.appointmentId,
    this.paymentUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppointmentDetailsSection(
          appointmentId: appointmentId,
          paymentUrl: paymentUrl,
        ),
      ),
    );
  }
}
