import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Success card with booking details and reference number.
class BookingSuccessCard extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final TimeSlotModel selectedTime;
  final String? bookingRef;

  const BookingSuccessCard({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    this.bookingRef,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Checkmark
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 48,
            ),
          ),
          16.ph,
          Text(
            'booking_success'.tr(),
            style: AppStyles.s20Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          8.ph,
          Text(
            'booking_success_desc'.tr(),
            style: AppStyles.s14Medium.withColor(AppColors.grey500),
            textAlign: TextAlign.center,
          ),
          20.ph,
          // Reference
          if (bookingRef != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 18,
                    color: AppColors.stitchPrimary,
                  ),
                  8.pw,
                  Text(
                    bookingRef!,
                    style: AppStyles.s16Bold.withColor(AppColors.stitchPrimary),
                  ),
                ],
              ),
            ),
            20.ph,
          ],
          Container(height: 1, color: AppColors.grey200),
          20.ph,
          // Doctor
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
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
                        size: 24,
                      )
                    : null,
              ),
              12.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.displayName,
                    style: AppStyles.s14Bold.withColor(
                      AppColors.stitchPrimaryContainer,
                    ),
                  ),
                  4.ph,
                  Text(
                    doctor.displaySpecialty,
                    style: AppStyles.s12Medium.withColor(
                      AppColors.stitchSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.ph,
          // Date & Time
          Row(
            children: [
              Expanded(
                child: _DetailChip(
                  icon: Icons.calendar_month_rounded,
                  value: DateFormat('MMM d, yyyy').format(selectedDate),
                ),
              ),
              12.pw,
              Expanded(
                child: _DetailChip(
                  icon: Icons.schedule_rounded,
                  value: DateFormat('hh:mm a').format(selectedTime.startTime),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String value;
  const _DetailChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.stitchSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.stitchPrimary),
          8.pw,
          Flexible(
            child: Text(
              value,
              style: AppStyles.s13Medium.withColor(AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
