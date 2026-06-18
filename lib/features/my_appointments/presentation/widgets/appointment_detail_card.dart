import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';

class AppointmentDetailCard extends StatelessWidget {
  final AppointmentResponseDto appointment;

  const AppointmentDetailCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stitchSurfaceLow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.stitchPrimaryFixed,
                child: Icon(Icons.person, color: AppColors.stitchPrimary, size: 32),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.doctorName,
                      style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer)),
                    if (appointment.clinicName != null)
                      Text(appointment.clinicName!,
                        style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary)),
                  ],
                ),
              ),
              AppointmentStatusBadge(status: appointment.status),
            ],
          ),
          20.ph,
          const Divider(color: AppColors.stitchSurfaceLow),
          16.ph,
          _row(Icons.calendar_month_rounded, 'date'.tr(),
            DateFormat('EEEE, MMM d, yyyy').format(appointment.appointmentDate)),
          12.ph,
          _row(Icons.schedule_rounded, 'time'.tr(),
            '${appointment.startTime} - ${appointment.endTime}'),
          12.ph,
          _row(Icons.category_outlined, 'appointment_type'.tr(),
            _typeLabel(appointment.appointmentType)),
          12.ph,
          if (appointment.bookingRef != null)
            _row(Icons.receipt_long_rounded, 'booking_ref'.tr(), appointment.bookingRef!),
          12.ph,
          if (appointment.amount != null)
            _row(Icons.payments_rounded, 'consultation_fee'.tr(),
              '${appointment.currency ?? "SAR"} ${appointment.amount!.toStringAsFixed(0)}'),
          12.ph,
          _row(Icons.person_outline, 'patient'.tr(), appointment.patientFullName),
          12.ph,
          _row(Icons.phone_outlined, 'phone'.tr(), appointment.patientPhoneNumber),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.stitchPrimaryContainer),
        10.pw,
        Text('$label: ', style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary)),
        Expanded(
          child: Text(value,
            style: AppStyles.s14Medium.withColor(AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _typeLabel(int type) {
    switch (type) {
      case 1: return 'in_person'.tr();
      case 2: return 'online'.tr();
      case 3: return 'follow_up'.tr();
      default: return '';
    }
  }
}
