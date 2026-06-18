import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/specialty_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';

class HomeSpecialtiesListWidget extends StatelessWidget {
  final List<SpecialtyModel> specialties;
  final VoidCallback onSeeAll;
  final Function(SpecialtyModel)? onSpecialtyTap;

  const HomeSpecialtiesListWidget({
    super.key,
    required this.specialties,
    required this.onSeeAll,
    this.onSpecialtyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16).copyWith(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n('specialties'),
                style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  context.l10n('see_all'),
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.stitchPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specialties.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final specialty = specialties[index];
              return SpecialtyItemWidget(
                specialty: specialty,
                onTap: () => onSpecialtyTap?.call(specialty),
              );
            },
          ),
        ),
      ],
    );
  }
}
