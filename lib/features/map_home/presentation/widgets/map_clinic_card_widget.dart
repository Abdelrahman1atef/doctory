import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MapClinicCardWidget extends StatelessWidget {
  final ClinicModel clinic;
  final bool isSelected;
  final VoidCallback onTap;

  const MapClinicCardWidget({
    super.key,
    required this.clinic,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryContainer.withValues(alpha: 0.05)
              : AppColors.stitchSurfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.stitchPrimaryContainer
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    clinic.imageUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.stitchSurfaceLow,
                      child: const Icon(
                        Icons.local_hospital,
                        color: AppColors.stitchSecondary,
                      ),
                    ),
                  ),
                ),
                12.pw,
                // Details
                Expanded(
                  child: Column(
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
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                4.pw,
                                Text(
                                  clinic.rating.toString(),
                                  style: AppStyles.s13Bold.withColor(
                                    AppColors.stitchSecondary,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      4.ph,
                      Text(
                        clinic.displayDescription,
                        style: AppStyles.s13Medium.withColor(
                          AppColors.stitchSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.ph,
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: clinic.isOpen
                                ? AppColors.success
                                : AppColors.errorColor,
                          ),
                          6.pw,
                          Text(
                            clinic.isOpen ? 'open_now'.tr() : 'closed'.tr(),
                            style: AppStyles.s12Medium.withColor(
                              clinic.isOpen
                                  ? AppColors.success
                                  : AppColors.errorColor,
                            ),
                          ),
                          if (isSelected) ...[
                            const Spacer(),
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.stitchSecondary,
                            ),
                            4.pw,
                            Text(
                              clinic.distanceFormatted,
                              style: AppStyles.s12Bold.withColor(
                                AppColors.stitchSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              16.ph,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.stitchPrimaryContainer.withValues(
                        alpha: 0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: AppColors.stitchPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Action already handled by parent tap
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stitchPrimaryContainer,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'book_appointment'.tr(),
                        style: AppStyles.s14Bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
