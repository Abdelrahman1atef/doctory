import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Styled text field for booking form inputs.
class BookingTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const BookingTextField({
    super.key,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppStyles.s14Medium.withColor(AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.s14Medium.withColor(AppColors.grey500),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 40 : 0),
          child: Icon(icon, color: AppColors.stitchSecondary, size: 20),
        ),
        filled: true,
        fillColor: AppColors.stitchSurfaceLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.stitchPrimary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
