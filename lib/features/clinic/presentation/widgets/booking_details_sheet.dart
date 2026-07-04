import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingDetailsSheet {
  static void show(BuildContext context, BookingRequestModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BookingDetailsContent(booking: booking),
    );
  }
}

class _BookingDetailsContent extends StatelessWidget {
  final BookingRequestModel booking;

  const _BookingDetailsContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          20.ph,
          Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor:
                  AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
              child: Text(
                booking.patientName[0],
                style: AppStyles.s24Bold.withColor(AppColors.stitchPrimary),
              ),
            ),
          ),
          12.ph,
          Center(
            child: Text(
              booking.patientName,
              style: AppStyles.s18Bold.withColor(AppColors.textPrimary),
            ),
          ),
          24.ph,
          _infoRow(
            icon: Icons.phone_outlined,
            label: 'phone'.tr(),
            value: booking.patientPhone ?? '---',
          ),
          if (booking.patientAge != null)
            _infoRow(
              icon: Icons.cake_outlined,
              label: 'patient_age'.tr(),
              value: '${booking.patientAge}',
            ),
          _infoRow(
            icon: Icons.local_hospital_outlined,
            label: LocaleKeys.clinic_name.tr(),
            value: booking.clinicName,
          ),
          if (booking.doctorName != null)
            _infoRow(
              icon: Icons.person_outline,
              label: LocaleKeys.doctor_name.tr(),
              value: booking.doctorName!,
            ),
          _infoRow(
            icon: Icons.calendar_today_outlined,
            label: LocaleKeys.appointment_date.tr(),
            value: booking.requestedDate,
          ),
          _infoRow(
            icon: Icons.access_time_rounded,
            label: LocaleKeys.appointment_time.tr(),
            value: booking.requestedTime,
          ),
          _infoRow(
            icon: Icons.event_note_outlined,
            label: 'appointment_type'.tr(),
            value: _appointmentTypeLabel(booking.appointmentType),
          ),
          if (booking.reason != null && booking.reason!.isNotEmpty)
            _infoRow(
              icon: Icons.notes_rounded,
              label: LocaleKeys.reason.tr(),
              value: booking.reason!,
            ),
          16.ph,
          Center(
            child: StatusBadge(booking.status),
          ),
        ],
      ),
    );
  }

  String _appointmentTypeLabel(AppointmentType type) {
    switch (type) {
      case AppointmentType.inPerson:
        return 'in_person'.tr();
      case AppointmentType.online:
        return 'online'.tr();
      case AppointmentType.followUp:
        return 'follow_up'.tr();
    }
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.stitchPrimary),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppStyles.s13Medium.withColor(AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.s14SemiBold.withColor(AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String text;

    switch (status) {
      case BookingStatus.pending:
        color = AppColors.warning;
        text = LocaleKeys.pending.tr();
      case BookingStatus.accepted:
        color = AppColors.success;
        text = LocaleKeys.accepted.tr();
      case BookingStatus.rejected:
        color = AppColors.error;
        text = LocaleKeys.rejected.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppStyles.s14Bold.withColor(color),
      ),
    );
  }
}
