import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_doctor_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_names.dart';

class ClinicDoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;

  const ClinicDoctorsSection({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'available_doctors'.tr(),
                style: AppStyles.s18Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              Text(
                '${doctors.length}',
                style: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
              ),
            ],
          ),
        ),
        16.ph,
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return ClinicDoctorCardWidget(
                doctor: doctors[index],
                onTap: () {
                  context.push(AppRoutes.doctorDetails, extra: doctors[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
