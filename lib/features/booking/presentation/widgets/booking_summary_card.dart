import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_info_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Summary card displayed on the confirmation step.
class BookingSummaryCard extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final TimeSlotModel selectedTime;
  final double consultationFee;
  final String currency;

  const BookingSummaryCard({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultationFee,
    required this.currency,
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
                          image: NetworkImage(doctor.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: doctor.imageUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.stitchPrimary,
                        size: 28,
                      )
                    : null,
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.displayName,
                      style: AppStyles.s16Bold.withColor(
                        AppColors.stitchPrimaryContainer,
                      ),
                    ),
                    4.ph,
                    Text(
                      doctor.displaySpecialty,
                      style: AppStyles.s13Medium.withColor(
                        AppColors.stitchSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.ph,
          Container(height: 1, color: AppColors.grey200),
          20.ph,
          BookingInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'date'.tr(),
            value: DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
          ),
          16.ph,
          BookingInfoRow(
            icon: Icons.schedule_rounded,
            label: 'time'.tr(),
            value: DateFormat('hh:mm a').format(selectedTime.startTime),
          ),
          16.ph,
          BookingInfoRow(
            icon: Icons.payments_rounded,
            label: 'consultation_fee'.tr(),
            value: '$currency ${consultationFee.toStringAsFixed(0)}',
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
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.info,
                ),
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
}
