import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/presentation/sections/appointment_details_section.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsView extends StatelessWidget {
  final AppointmentResponseDto appointment;

  const AppointmentDetailsView({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppointmentDetailsSection(appointment: appointment),
      ),
    );
  }
}
