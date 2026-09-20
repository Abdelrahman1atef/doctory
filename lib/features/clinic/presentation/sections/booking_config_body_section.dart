import 'package:doctory/features/clinic/presentation/sections/booking_config_appbar_section.dart';
import 'package:doctory/features/clinic/presentation/sections/booking_config_form_section.dart';
import 'package:flutter/material.dart';

class BookingConfigBodySection extends StatelessWidget {
  const BookingConfigBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BookingConfigAppBarSection(),
        Expanded(
          child: BookingConfigFormSection(),
        ),
      ],
    );
  }
}
