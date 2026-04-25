import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/home/data/model/specialty_model.dart';
import 'package:doctory/features/home/presentation/widgets/specialty_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeSpecialtiesSection extends StatelessWidget {
  final List<SpecialtyModel> specialties;

  const HomeSpecialtiesSection({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('specialties'),
          style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specialties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return SpecialtyItemWidget(specialty: specialties[index]);
            },
          ),
        ),
      ],
    );
  }
}
