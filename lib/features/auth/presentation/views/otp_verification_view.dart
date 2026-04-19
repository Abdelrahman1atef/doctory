import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/auth/presentation/sections/otp_header_section.dart';
import 'package:doctory/features/auth/presentation/sections/otp_input_section.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class OtpVerificationView extends StatelessWidget {
  final String? email;
  const OtpVerificationView({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.stitchPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              /// Header Section
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: OtpHeaderSection(email: email),
              ),
              
              const SizedBox(height: 60),
              
              /// Input Section
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: const OtpInputSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
