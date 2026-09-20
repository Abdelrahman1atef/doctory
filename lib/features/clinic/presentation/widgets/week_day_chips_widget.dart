import 'package:doctory/core/enums/week_day.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Seven selectable day chips (Sunday first, matching the API's 0-6 index).
class WeekDayChipsWidget extends StatelessWidget {
  final WeekDay selected;
  final ValueChanged<WeekDay> onSelected;

  const WeekDayChipsWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WeekDay.values.map((day) {
        final isSelected = day == selected;
        return GestureDetector(
          onTap: () => onSelected(day),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.stitchPrimary.withValues(alpha: 0.1)
                  : AppColors.stitchSurfaceLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.stitchPrimary : AppColors.cardBorder,
              ),
            ),
            child: Text(
              day.labelKey.tr(),
              style: AppStyles.s12Medium.copyWith(
                color: isSelected ? AppColors.stitchPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
