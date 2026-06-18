import 'package:doctory/features/booking/presentation/sections/booking_body_section.dart';
import 'package:doctory/features/booking/presentation/sections/booking_fab_section.dart';
import 'package:flutter/material.dart';

class BookingFlowView extends StatelessWidget {
  const BookingFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const BookingBodySection(),
      ),
      bottomNavigationBar: const BookingFabSection(),
    );
  }
}
