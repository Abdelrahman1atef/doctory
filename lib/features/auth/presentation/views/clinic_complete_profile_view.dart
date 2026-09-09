import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/clinic_complete_profile_section.dart';
import 'package:flutter/material.dart';

class ClinicCompleteProfileView extends StatelessWidget {
  final bool isSetupMode;

  const ClinicCompleteProfileView({super.key, this.isSetupMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: ClinicCompleteProfileSection(isSetupMode: isSetupMode),
    );
  }
}
