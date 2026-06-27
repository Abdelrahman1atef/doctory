import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClinicHeaderSection extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicHeaderSection({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinic.displayName,
                style: AppStyles.s24Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              8.ph,
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                  4.pw,
                  Text(
                    clinic.rating.roundTo2numberString,
                    style: AppStyles.s14Bold.withColor(
                      AppColors.stitchSecondary,
                    ),
                  ),
                  8.pw,
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.patientReviews,extra: clinic,),
                    child: Text(
                      '(${clinic.reviewsCount} ${'reviews'.tr()})',
                      style: AppStyles.s14Medium
                          .withColor(AppColors.stitchSecondary)
                          .underline(),
                    ),
                  ),
                ],
              ),
              16.ph,
              Text(
                clinic.displayDescription,
                style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
