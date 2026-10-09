import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Loading placeholder for the appointments list, drawn from the real card
/// so the skeleton matches the loaded layout.
class AppointmentsSkeletonWidget extends StatelessWidget {
  static const int _itemCount = 6;

  /// Only its shape is shown — every text is rendered as a skeleton bone.
  static final AppointmentResponseDto _placeholder = AppointmentResponseDto(
    id: '',
    doctorId: '',
    doctorName: 'Doctor full name',
    clinicId: '',
    clinicName: 'Clinic name here',
    appointmentDate: DateTime(2026),
    startTime: '10:00 AM',
    endTime: '10:30 AM',
    appointmentType: 0,
    createdAt: DateTime(2026),
  );

  const AppointmentsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _itemCount,
        itemBuilder: (context, index) => AppointmentCardWidget(
          appointment: _placeholder,
          onTap: () {},
        ),
      ),
    );
  }
}
