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
          if (clinic.phone != null && clinic.phone!.isNotEmpty) ...[
            16.ph,
            _buildInfoRow(Icons.phone_outlined, clinic.phone!),
          ],
          if (clinic.email != null && clinic.email!.isNotEmpty) ...[
            16.ph,
            _buildInfoRow(Icons.email_outlined, clinic.email!),
          ],
          if (clinic.website != null && clinic.website!.isNotEmpty) ...[
            16.ph,
            _buildInfoRow(Icons.language_outlined, clinic.website!),
          ],
          if (clinic.ownerName != null && clinic.ownerName!.isNotEmpty) ...[
            16.ph,
            const Divider(color: AppColors.stitchSurfaceLow),
            16.ph,
            _buildOwnerSection(),
          ],
          16.ph,
          const Divider(color: AppColors.stitchSurfaceLow),
          16.ph,
          _buildOperatingHoursSection(),
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'owner'.tr(),
          style:
              AppStyles.s16SemiBold.withColor(AppColors.stitchPrimaryContainer),
        ),
        12.ph,
        _buildInfoRow(Icons.person_outline, clinic.ownerName!),
        if (clinic.ownerEmail != null && clinic.ownerEmail!.isNotEmpty) ...[
          12.ph,
          _buildInfoRow(Icons.email_outlined, clinic.ownerEmail!),
        ],
        if (clinic.ownerPhone != null && clinic.ownerPhone!.isNotEmpty) ...[
          12.ph,
          _buildInfoRow(Icons.phone_outlined, clinic.ownerPhone!),
        ],
        if (clinic.subscriptionStatus != null) ...[
          12.ph,
          _buildSubscriptionStatus(),
        ],
      ],
    );
  }

  Widget _buildSubscriptionStatus() {
    final isActive = clinic.subscriptionStatus == null ||
        clinic.subscriptionStatus!.isEmpty;
    return Row(
      children: [
        const Icon(Icons.verified_user_outlined,
            color: AppColors.stitchPrimaryContainer, size: 20),
        8.pw,
        Text(
          isActive ? 'subscription_active'.tr() : clinic.subscriptionStatus!,
          style: AppStyles.s14Medium.withColor(
            isActive ? AppColors.success : AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildOperatingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              style: AppStyles.s16SemiBold
                  .withColor(AppColors.stitchPrimaryContainer),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: clinic.isOpen
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                clinic.isOpen ? 'open_now'.tr() : 'closed'.tr(),
                style: AppStyles.s12Bold.withColor(
                  clinic.isOpen
                      ? AppColors.success
                      : AppColors.errorColor,
                ),
              ),
            ),
          ],
        ),
        if (clinic.operatingHours != null) ...[
          12.ph,
          ...clinic.operatingHours!.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.key,
                    style: AppStyles.s14Medium
                        .withColor(AppColors.stitchSecondary),
                  ),
                  Text(
                    e.value,
                    style: AppStyles.s14Medium
                        .withColor(AppColors.stitchPrimaryContainer),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
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
