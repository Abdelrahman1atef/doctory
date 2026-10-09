import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_doctor_card_widget.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_doctors_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClinicDoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final String clinicId;

  const ClinicDoctorsSection({
    super.key,
    required this.doctors,
    required this.clinicId,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClinicDoctorsHeaderWidget(count: doctors.length),
        16.ph,
        for (final doctor in doctors) ...[
          ClinicDoctorCardWidget(
            doctor: doctor,
            onTap: () => _openDoctorDetails(context, doctor),
            onBook: () => _bookAppointment(context, doctor),
          ),
          if (doctor != doctors.last) 12.ph,
        ],
      ],
    );
  }

  void _openDoctorDetails(BuildContext context, DoctorModel doctor) {
    context.push(AppRoutes.doctorDetails, extra: doctor);
  }

  /// Booking slots are built from the doctor's availabilities. When the clinic
  /// payload doesn't include them, the doctor profile loads the full data and
  /// offers the same booking button.
  void _bookAppointment(BuildContext context, DoctorModel doctor) {
    final availabilities = doctor.availabilities;
    if (availabilities == null || availabilities.isEmpty) {
      _openDoctorDetails(context, doctor);
      return;
    }

    context.push(
      AppRoutes.bookingSelectDate,
      extra: {
        'doctor': doctor,
        'clinicId': clinicId,
      },
    );
  }
}
