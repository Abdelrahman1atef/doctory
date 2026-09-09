import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpecialtyItemWidget extends StatelessWidget {
  final SpecialtyModel specialty;
  final VoidCallback? onTap;

  const SpecialtyItemWidget({super.key, required this.specialty, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.stitchPrimary.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.stitchPrimary.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      specialty.iconUrl != null && specialty.iconUrl!.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: "https://doctory-icare.runasp.net/files/${specialty.iconUrl!}",
                            width: 24,
                            height: 24,
                            placeholder:
                                (context, url) => const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => const Icon(
                                  Icons.medical_services_outlined,
                                  color: AppColors.stitchPrimary,
                                  size: 20,
                                ),
                          )
                          : specialty.iconAsset != null &&
                              specialty.iconAsset!.isNotEmpty
                          ? SvgPicture.asset(
                            specialty.iconAsset!,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.stitchPrimary,
                              BlendMode.srcIn,
                            ),
                          )
                          : const Icon(
                            Icons.medical_services_outlined,
                            color: AppColors.stitchPrimary,
                            size: 20,
                          ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                specialty.displayName,
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
