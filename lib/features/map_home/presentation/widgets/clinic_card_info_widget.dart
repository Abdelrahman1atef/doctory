import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClinicCardInfoWidget extends StatelessWidget {
  final ClinicModel clinic;
  final bool showDistance;

  const ClinicCardInfoWidget({
    super.key,
    required this.clinic,
    this.showDistance = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      clinic.displayName,
                      style: AppStyles.s16Bold.withColor(
                        AppColors.stitchPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (clinic.isRegistered) ...[
                    6.pw,
                    const Icon(
                      Icons.verified,
                      color: AppColors.stitchPrimary,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
            if (clinic.rating > 0)
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  4.pw,
                  Text(
                    clinic.rating.toString(),
                    style: AppStyles.s13Bold.withColor(AppColors.stitchSecondary),
                  ),
                ],
              ),
          ],
        ),
        4.ph,
        Text(
          clinic.displayDescription,
          style: AppStyles.s13Medium.withColor(AppColors.stitchSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        8.ph,
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: clinic.isOpen ? AppColors.success : AppColors.errorColor,
            ),
            6.pw,
            Text(
              clinic.isOpen ? 'open_now'.tr() : 'closed'.tr(),
              style: AppStyles.s12Medium.withColor(
                clinic.isOpen ? AppColors.success : AppColors.errorColor,
              ),
            ),
            if (showDistance) ...[
              const Spacer(),
              const Icon(Icons.location_on, size: 14, color: AppColors.stitchSecondary),
              4.pw,
              Text(
                clinic.distanceFormatted,
                style: AppStyles.s12Bold.withColor(AppColors.stitchSecondary),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
