import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingGenderDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int?> onChanged;

  const BookingGenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      key: ValueKey(value),
      initialValue: value,
      items: [
        DropdownMenuItem(value: 1, child: Text('male'.tr())),
        DropdownMenuItem(value: 2, child: Text('female'.tr())),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'gender'.tr(),
        prefixIcon: const Icon(Icons.wc_rounded, color: AppColors.stitchPrimary),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
      ),
    );
  }
}
