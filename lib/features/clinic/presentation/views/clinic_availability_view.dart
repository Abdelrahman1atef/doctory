import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/clinic/presentation/sections/clinic_availability_body_section.dart';
import 'package:flutter/material.dart';

class ClinicAvailabilityView extends StatelessWidget {
  const ClinicAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: ClinicAvailabilityBodySection(),
      ),
    );
  }
}
