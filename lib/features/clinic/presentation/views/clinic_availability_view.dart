import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/clinic/presentation/sections/clinic_availability_section.dart';

class ClinicAvailabilityView extends StatelessWidget {
  const ClinicAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('clinic.availability_title'.tr()),
      ),
      body: const ClinicAvailabilitySection(),
    );
  }
}
