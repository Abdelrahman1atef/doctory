import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/home/data/model/specialty_model.dart';
import 'package:flutter/material.dart';

class SpecialtyItemWidget extends StatelessWidget {
  final SpecialtyModel specialty;

  const SpecialtyItemWidget({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {},
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
                  border: Border.all(color: AppColors.stitchPrimary.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.stitchPrimary.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.stitchPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                specialty.name,
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
