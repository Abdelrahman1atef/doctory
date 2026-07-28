import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../sections/clinic_complete_profile_section.dart';

class ClinicCompleteProfileView extends StatelessWidget {
  final bool isSetupMode;

  const ClinicCompleteProfileView({super.key, this.isSetupMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: ClinicCompleteProfileSection(isSetupMode: isSetupMode),
      ),
    );
  }
}
