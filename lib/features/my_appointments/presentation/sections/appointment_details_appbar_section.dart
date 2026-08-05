import 'package:doctory/features/my_appointments/presentation/widgets/appointment_header_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsAppBarSection extends StatelessWidget {
  final VoidCallback onBack;

  const AppointmentDetailsAppBarSection({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppointmentHeaderWidget(
      title: 'appointment_details'.tr(),
      onBack: onBack,
    );
  }
}