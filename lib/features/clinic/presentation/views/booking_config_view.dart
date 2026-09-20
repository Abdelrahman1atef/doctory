import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/clinic/presentation/sections/booking_config_body_section.dart';
import 'package:flutter/material.dart';

class BookingConfigView extends StatelessWidget {
  const BookingConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: BookingConfigBodySection(),
      ),
    );
  }
}
