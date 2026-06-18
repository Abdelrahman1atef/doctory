import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';

class AppointmentCardWidget extends StatelessWidget {
  final AppointmentResponseDto appointment;
  final VoidCallback onTap;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(appointment.appointmentDate);
    final timeStr = '${appointment.startTime} - ${appointment.endTime}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stitchSurfaceLow),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.stitchPrimaryFixed,
                child: Icon(Icons.person, color: AppColors.stitchPrimary, size: 28),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: AppStyles.s16Bold.withColor(AppColors.stitchPrimaryContainer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.ph,
                    if (appointment.clinicName != null && appointment.clinicName!.isNotEmpty)
                      Text(
                        appointment.clinicName!,
                        style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    6.ph,
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.stitchSecondary),
                        4.pw,
                        Flexible(
                          child: Text(dateStr, style: AppStyles.s12Medium.withColor(AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis),
                        ),
                        12.pw,
                        const Icon(Icons.schedule, size: 14, color: AppColors.stitchSecondary),
                        4.pw,
                        Flexible(
                          child: Text(timeStr, style: AppStyles.s12Medium.withColor(AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              8.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppointmentStatusBadge(status: appointment.status),
                  8.ph,
                  const Icon(Icons.chevron_right, color: AppColors.stitchSecondary, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
