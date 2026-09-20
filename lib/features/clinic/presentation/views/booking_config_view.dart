import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/clinic/presentation/sections/booking_config_section.dart';

class BookingConfigView extends StatelessWidget {
  const BookingConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('clinic.booking_config_title'.tr()),
      ),
      body: const BookingConfigSection(),
    );
  }
}
