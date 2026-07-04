import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/presentation/widgets/booking_details_sheet.dart';
import 'package:doctory/features/clinic/presentation/widgets/status_badge_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingRequestCardWidget extends StatelessWidget {
  final BookingRequestModel booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const BookingRequestCardWidget({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BookingDetailsSheet.show(context, booking),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      AppColors.stitchPrimaryFixed.withValues(alpha: 0.2),
                  child: Text(
                    booking.patientName[0],
                    style: AppStyles.s16Bold.withColor(AppColors.stitchPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.patientName,
                        style: AppStyles.s14SemiBold.withColor(
                          AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        booking.clinicName,
                        style: AppStyles.s12Medium.withColor(
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadgeWidget.pending(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${booking.requestedDate} - ${booking.requestedTime}',
                  style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
                ),
              ],
            ),
            if (booking.reason != null && booking.reason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                booking.reason!,
                style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: onReject,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.error.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.rejectButton.tr(),
                        style:
                            AppStyles.s14Medium.withColor(AppColors.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: onAccept,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.accept.tr(),
                        style:
                            AppStyles.s14Medium.withColor(AppColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
