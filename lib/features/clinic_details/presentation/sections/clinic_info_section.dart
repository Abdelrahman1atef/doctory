import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClinicInfoSection extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicInfoSection({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.location_on_outlined, clinic.displayAddress),
          16.ph,
          _buildInfoRow(Icons.phone_outlined, clinic.phone ?? ''),
          16.ph,
          const Divider(color: AppColors.stitchSurfaceLow),
          16.ph,
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.stitchPrimaryContainer,
                size: 24,
              ),
              12.pw,
              Text(
                'operating_hours'.tr(),
                style: AppStyles.s16SemiBold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: clinic.isOpen
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  clinic.isOpen ? 'open_now'.tr() : 'closed'.tr(),
                  style: AppStyles.s12Bold.withColor(
                    clinic.isOpen ? AppColors.success : AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),
          12.ph,
          if (clinic.operatingHours != null)
            ...clinic.operatingHours!.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: AppStyles.s14Medium.withColor(
                        AppColors.stitchSecondary,
                      ),
                    ),
                    Text(
                      e.value,
                      style: AppStyles.s14Medium.withColor(
                        AppColors.stitchPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.stitchPrimaryContainer, size: 24),
        12.pw,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s14Medium.withColor(AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
