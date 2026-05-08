import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/doctor_card_widget.dart';
import 'package:doctory/features/home/presentation/widgets/clinic_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/router/router_names.dart';

import '../../../../core/utils/extensions.dart';

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
                context.l10n('featured_clinics'),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: onSeeAllClinics,
                child: Text(
                  context.l10n('see_all'),
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
                context.l10n('recommended_doctors'),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: onSeeAllDoctors,
                child: Text(
                  context.l10n('see_all'),
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
