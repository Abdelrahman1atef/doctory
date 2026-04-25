import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/search_results/data/model/hospital_model.dart';
import 'package:flutter/material.dart';

class HospitalListItemWidget extends StatelessWidget {
  final HospitalModel hospital;
  final bool isSelected;
  final VoidCallback onTap;

  const HospitalListItemWidget({
    super.key,
    required this.hospital,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: AppColors.stitchPrimary, width: 2)
              : null,
        ),
        child: Column(
          children: [
            // Top Status & Distance Row
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'متاح اليوم',
                      style: AppStyles.s10Bold.copyWith(
                        color: AppColors.stitchPrimary,
                      ),
                    ),
                  ),
                  // Distance Badge
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.stitchSecondary),
                      const SizedBox(width: 4),
                      Text(
                        hospital.distanceFormatted,
                        style: AppStyles.s10Bold.copyWith(
                          color: AppColors.stitchSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Middle Section: Image + Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Doctor Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.stitchSurface, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3774/3774299.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital.displayName,
                          style: AppStyles.s16Bold.copyWith(
                            color: AppColors.stitchPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hospital.specializationName ?? 'أخصائي باطنة',
                          style: AppStyles.s12Medium.copyWith(
                            color: AppColors.stitchSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Rating Row
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Color(0xFFFFB800)),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: AppStyles.s12Bold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(120 تقييم)',
                              style: AppStyles.s10Medium.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            // Bottom Section: Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [

                  // Book Button
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.stitchPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'احجز الآن',
                          style: AppStyles.s14Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Directions Button (OSM)
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.stitchSurface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions,
                        color: AppColors.stitchPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Call Button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      color: AppColors.stitchPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
