import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/cards/doctor_card_widget.dart';
import 'package:doctory/features/home/presentation/widgets/cards/clinic_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/router/router_names.dart';

import 'package:easy_localization/easy_localization.dart';

class HomeFeaturedListWidget extends StatelessWidget {
  final List<DoctorModel> doctors;
  final List<ClinicModel> clinics;
  final VoidCallback onSeeAllClinics;
  final VoidCallback onSeeAllDoctors;

  const HomeFeaturedListWidget({
    super.key,
    required this.doctors,
    required this.clinics,
    required this.onSeeAllClinics,
    required this.onSeeAllDoctors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (clinics.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'featured_clinics'.tr(),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: onSeeAllClinics,
                child: Text(
                  'see_all'.tr(),
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.stitchPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...clinics.map(
            (clinic) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClinicCardWidget(
                clinic: clinic,
                onTap: () {
                  context.push(AppRoutes.clinicDetails, extra: clinic);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (doctors.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'recommended_doctors'.tr(),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: onSeeAllDoctors,
                child: Text(
                  'see_all'.tr(),
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.stitchPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...doctors.map(
            (doctor) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DoctorCardWidget(
                doctor: doctor,
                onTap: () {
                  context.push(AppRoutes.doctorDetails, extra: doctor);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
