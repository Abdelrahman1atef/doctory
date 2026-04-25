import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/featured_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeFeaturedSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final List<ClinicModel> clinics;

  const HomeFeaturedSection({
    super.key,
    required this.doctors,
    required this.clinics,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty && clinics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (clinics.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('featured_clinics'),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  context.tr('see_all'),
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
              child: ClinicCardWidget(clinic: clinic),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (doctors.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('recommended_doctors'),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  context.tr('see_all'),
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
              child: DoctorCardWidget(doctor: doctor),
            ),
          ),
        ],
      ],
    );
  }
}
