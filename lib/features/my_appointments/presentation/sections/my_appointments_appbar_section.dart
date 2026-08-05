import 'package:doctory/features/my_appointments/presentation/widgets/appointment_header_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyAppointmentsAppBarSection extends StatelessWidget {
  const MyAppointmentsAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppointmentHeaderWidget(title: 'my_appointments'.tr());
  }
}