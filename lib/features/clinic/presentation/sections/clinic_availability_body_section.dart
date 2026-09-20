import 'package:doctory/features/clinic/presentation/sections/clinic_availability_actions_section.dart';
import 'package:doctory/features/clinic/presentation/sections/clinic_availability_appbar_section.dart';
import 'package:doctory/features/clinic/presentation/sections/clinic_availability_list_section.dart';
import 'package:flutter/material.dart';

class ClinicAvailabilityBodySection extends StatelessWidget {
  const ClinicAvailabilityBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ClinicAvailabilityAppBarSection(),
        Expanded(
          child: ClinicAvailabilityListSection(),
        ),
        ClinicAvailabilityActionsSection(),
      ],
    );
  }
}
