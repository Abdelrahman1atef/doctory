import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../sections/clinic_complete_profile_section.dart';

class ClinicCompleteProfileView extends StatelessWidget {
  const ClinicCompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: ClinicCompleteProfileSection(),
      ),
    );
  }
}
