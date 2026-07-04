import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final BookingRequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Text(request.patientName[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.patientName,
                      style: AppStyles.s14SemiBold.withColor(
                        AppColors.textPrimary,
                      ),
                    ),
                    if (request.patientPhone != null)
                      Text(
                        request.patientPhone!,
                        style: AppStyles.s12Medium.withColor(
                          AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(request.requestedDate),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(request.requestedTime),
            ],
          ),
          if (request.reason != null && request.reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              request.reason!,
              style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.stitchPrimary,
                  side: const BorderSide(color: AppColors.stitchPrimary),
                ),
                child: Text(LocaleKeys.rejectButton.tr()),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimary,
                  foregroundColor: AppColors.white,
                ),
                child: Text(LocaleKeys.accept.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
