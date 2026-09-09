import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/home/presentation/widgets/header/home_doctor_type_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Greeting column: time-of-day line, the user's name, and the help prompt.
class HomeGreetingWidget extends StatelessWidget {
  final String userName;
  final DoctorEmploymentType? doctorType;

  const HomeGreetingWidget({
    super.key,
    required this.userName,
    this.doctorType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'good_morning'.tr(),
          style: AppStyles.s16Medium.copyWith(color: AppColors.textSecondary),
        ),
        10.ph,
        Text(
          'hello_user'.tr(args: [userName]),
          style: AppStyles.s24Bold.copyWith(color: AppColors.stitchPrimary),
        ),
        if (doctorType != null) ...[
          4.ph,
          HomeDoctorTypeChip(doctorType: doctorType!),
        ],
        8.ph,
        Text(
          'how_can_we_help'.tr(),
          style: AppStyles.s18Bold.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
