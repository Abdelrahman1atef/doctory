import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_info_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
@Preview(name: 'My Custom Button', textScaleFactor: 1.0)
Widget previewMyButton() {
  return ElevatedButton(
    onPressed: () {},
    child: const Text('Click Me'),
  );
}
class BookingSummaryCard extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final TimeSlotModel selectedTime;
  final double consultationFee;
  final String currency;
  final int appointmentType;
  final String patientName;

  const BookingSummaryCard({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultationFee,
    required this.currency,
    this.appointmentType = 1,
    this.patientName = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.stitchPrimaryFixed,
                  image: doctor.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(doctor.imageUrl!.toImageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: doctor.imageUrl == null
                    ? const Icon(Icons.person, color: AppColors.stitchPrimary, size: 28)
                    : null,
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.displayName,
                      style: AppStyles.s16Bold.withColor(AppColors.stitchPrimaryContainer),
                    ),
                    4.ph,
                    Text(doctor.displaySpecialty,
                      style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.ph,
          if (patientName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BookingInfoRow(
                icon: Icons.person_outline,
                label: 'patient'.tr(),
                value: patientName,
              ),
            ),
          Container(height: 1, color: AppColors.grey200),
          16.ph,
          BookingInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'date'.tr(),
            value: DateFormat('EEEE, MMM d, yyyy', context.locale.toLanguageTag()).format(selectedDate),
          ),
          12.ph,
          BookingInfoRow(
            icon: Icons.schedule_rounded,
            label: 'time'.tr(),
            value: DateFormat('hh:mm a', context.locale.toLanguageTag()).format(selectedTime.startTime),
          ),
          12.ph,
          BookingInfoRow(
            icon: Icons.category_outlined,
            label: 'appointment_type'.tr(),
            value: _typeLabel(appointmentType),
          ),
          12.ph,
          BookingInfoRow(
            icon: Icons.payments_rounded,
            label: 'consultation_fee'.tr(),
            value: '${'currency_egp'.tr()} ${consultationFee.toStringAsFixed(0)}',
          ),
          20.ph,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.info),
                10.pw,
                Expanded(
                  child: Text(
                    'cancellation_policy_note'.tr(),
                    style: AppStyles.s12Medium.withColor(AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(int type) {
    switch (type) {
      case 0: return 'in_person'.tr();
      case 1: return 'follow_up'.tr();
      case 2: return 'online'.tr();
      default: return '';
    }
  }
}
